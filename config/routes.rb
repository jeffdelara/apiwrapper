Rails.application.routes.draw do
  root 'payment#index'
  post 'pay', to: 'payment#pay'
  post 'capture', to: 'payment#capture'
  get 'error', to: 'payment#error'
  get 'success', to: 'payment#success'

end
