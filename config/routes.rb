Rails.application.routes.draw do
  devise_for :teachers
  devise_for :admins
	root 'welcomes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'admin_index', to: 'admins#index'
  get 'teacher_index', to: 'teachers#index'
end
