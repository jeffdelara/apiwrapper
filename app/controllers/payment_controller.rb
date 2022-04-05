class PaymentController < ApplicationController

  def index
  end

  def pay 
    paymongo = Paymongo::V1::CardPayment.new
    amount = params[:amount].to_i * 100
    message = params[:message]

    begin 
      @payment_intent = paymongo.create_payment_intent(amount, message)
    rescue ApiExceptions::BadRequest
      redirect_to error_path
    end
  end

  def capture 
    payment_intent_id = params[:payment_intent_id]
    client_key = params[:client_key]
    card_details = {
      card_number: params[:card_number], 
      exp_month: params[:exp_month].to_i, 
      exp_year: params[:exp_year].to_i, 
      cvc: params[:cvc]
    }
    billing = {
      name: params[:name],
      email: params[:email]
    }

    paymongo = Paymongo::V1::CardPayment.new

    begin 
      @payment_method = paymongo.create_payment_method(card_details, billing)
    rescue ApiExceptions::BadRequest
      redirect_to error_path
    end
    
    payment_method_id = @payment_method['data']['id']
    
    begin 
      @response = paymongo.attach(
        payment_intent_id, 
        payment_method_id, 
        client_key
      )
    rescue ApiExceptions::BadRequest
      redirect_to error_path
    end
    
    redirect_to success_path 
  end

  def success 
  end

  def error 
  end
  
end
