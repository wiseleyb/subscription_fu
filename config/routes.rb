ActionController::Routing::Routes.draw do |map|

  map.resources :products
  map.resources :cim_payments
  map.resources :cim_profiles
  map.resources :subscriptions

end
