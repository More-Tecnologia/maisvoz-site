module Api
  class CreateVehicleProtection

    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    def call
      if find_user
        ActiveRecord::Base.transaction do
          create_subscription
          create_vehicle_protection
        end
        return subscription
      end
    end

    private

    attr_reader :params, :subscription, :user

    def create_subscription
      @subscription = ClubMotorsSubscription.new.tap do |s|
        s.user      = user
        s.car_model = find_car_model
        s.status    = ClubMotorsSubscription.statuses['pending']
        s.type      = ClubMotorsSubscription.types['ancore']
        s.plate      = params.dig('vistoria').dig('placa')
        s.chassis    = params.dig('vistoria').dig('chassis')
        s.cnpj_cpf   = params.dig('vistoria').dig('associado').dig('pessoa').dig('cpf_cnpj')
        s.owner_name = params.dig('vistoria').dig('associado').dig('fantasia')
        s.model_year = params.dig('vistoria').dig('preco_fipe').dig('ano_modelo')
        s.fuel       = params.dig('vistoria').dig('preco_fipe').dig('combustivel').try(:downcase)
        s.renavam    = params.dig('vistoria').dig('renavam')
        s.price      = params.dig('vistoria').dig('veiculo_plano').dig('valor_basico')
        s.current_period_start = Time.zone.today
        s.activated_at = Time.zone.today

        s.save!
      end
    end

    def create_vehicle_protection
      MooviIntegration.new.tap do |p|
        p.club_motors_subscription = subscription
        p.payload   = params
        p.placa     = params.dig('vistoria').dig('placa')
        p.status    = params.dig('vistoria').dig('status')
        p.fipe_code = params.dig('vistoria').dig('preco_fipe').dig('codigo')
        p.price     = params.dig('vistoria').dig('veiculo_plano').dig('valor_basico')

        p.save!
      end
    end

    def find_user
      if find_by_cpf.blank? && find_by_username.blank?
        errors.add(:user, 'not found')
        false
      else
        true
      end
    end

    def find_by_cpf
      cpf = params.dig('vistoria').dig('associado').dig('pessoa').dig('cpf_cnpj')
      cpf = CPF.new(cpf)

      return false if cpf.blank?

      @user = User.where('document_cpf = ? OR document_cpf = ?', cpf.formatted, cpf.stripped).first
    end

    def find_by_username
      username = params.dig('vistoriador').dig('login')

      return false if username.blank?

      @user = User.find_by(username: username)
    end

    def find_car_model
      fipe_code = params.dig('vistoria').dig('preco_fipe').dig('codigo')
      CarModel.find_by(fipe_code: fipe_code)
    end

  end
end
