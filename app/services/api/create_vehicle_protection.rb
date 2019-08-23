module Api
  class CreateVehicleProtection

    prepend SimpleCommand

    def initialize(params)
      @inspection = params[:inspection]
    end

    def call
      if find_user
        ActiveRecord::Base.transaction do
          create_subscription
          create_vehicle_protection
          create_order
        end
        return {
          order: order.hashid,
          type: order.type,
          name: user.name
        }
      end
    end

    private

    attr_reader :params, :inspection, :subscription, :user, :order

    def create_subscription
      @subscription = ClubMotorsSubscription.new.tap do |s|
        s.user                 = user
        s.status               = ClubMotorsSubscription.statuses['pending']
        s.type                 = ClubMotorsSubscription.types['ancore']
        s.car_model            = CarModel.find_by(name: inspection.dig('model'))
        s.plate                = inspection.dig('plate')
        s.chassis              = inspection.dig('chassis')
        s.cnpj_cpf             = inspection.dig('associated').dig('cpf_cnpj')
        s.owner_name           = inspection.dig('associated').dig('fantasy') || inspection.dig('associated').dig('name')
        s.model_year           = inspection.dig('year_fuel').split('/')[0].strip
        s.fuel                 = inspection.dig('year_fuel').split('/')[1].downcase.strip
        s.renavam              = inspection.dig('renavam')
        s.price                = inspection.dig('monthly_value').to_d
        s.balance_cents        = inspection.dig('monthly_value').to_d * 100
        s.current_period_start = Time.zone.today
        s.activated_at         = Time.zone.today

        s.save!
      end
    end

    def create_vehicle_protection
      InspectionIntegration.new.tap do |p|
        p.club_motors_subscription = subscription
        p.payload                  = inspection
        p.placa                    = inspection.dig('plate')
        p.status                   = inspection.dig('status')
        p.fipe_code                = inspection.dig('model')
        p.price                    = inspection.dig('monthly_value')

        p.save!
      end
    end

    def create_order
      @order = Order.new.tap do |order|
        order.status         = Order.statuses[:pending_payment]
        order.type           = Order.types[:futurepro_adhesion]
        order.user           = user
        order.payable        = subscription
        order.total_cents    = inspection.dig('monthly_value').to_d * 100
        order.subtotal_cents = inspection.dig('monthly_value').to_d * 100
        order.expire_at      = 10.days.from_now
        order.tax_cents      = 0
        order.shipping_cents = 0

        order.save!
      end
    end

    def send_notification
      InspectionMailer.with(inspection: subscription).approved.deliver_later
    end

    def find_user
      if find_by_cpf.blank? && find_by_cnpj.blank? && find_by_username.blank?
        errors.add(:user, 'not found')
        false
      else
        true
      end
    end

    def find_by_cpf
      cpf = inspection.dig('associated').dig('cpf_cnpj')

      return false if cpf.size > 14

      cpf = CPF.new(cpf)

      return false if cpf.blank?

      @user = User.where('document_cpf = ? OR document_cpf = ?', cpf.formatted, cpf.stripped).first
    end

    def find_by_cnpj
      cnpj = inspection.dig('associated').dig('cpf_cnpj')

      return false if cnpj.size > 14

      cnpj = CNPJ.new(cnpj)

      return false if cnpj.blank?

      @user = User.where('document_cnpj = ? OR document_cnpj = ?', cnpj.formatted, cnpj.stripped).first
    end

    def find_by_username
      username = inspection.dig('inspector_login')

      return false if username.blank?

      @user = User.find_by(username: username)
    end

  end
end
