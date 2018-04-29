class PagarmePostbackController < ActionController::Base

  def create
    if valid_postback?
      tx = PagarmeTransaction.find_by(pagarme_tid: params[:id])
      tx.status = params[:current_status]
      tx.paid_amount_cents = params[:transaction][:authorized_amount]
      tx.save!

      if params[:current_status] == 'paid' && tx.paid_amount_cents >= tx.order.total_cents
        PaymentCompensationWorker.perform_async(tx.order_id)
      elsif tx.paid_amount_cents < tx.order.total_cents
        raise "Payment received is less than total, order_id: #{tx.order_id}"
      end
    else
      render_invalid_postback_response
    end
  end

  protected

  def valid_postback?
    raw_post  = request.raw_post
    signature = request.headers['X-Hub-Signature']
    PagarMe::Postback.valid_request_signature?(raw_post, signature)
  end

  def render_invalid_postback_response
    render json: { error: 'invalid postback' }, status: 400
  end

end
