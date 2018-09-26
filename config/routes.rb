Rails.application.routes.draw do
  resources :taskas
  resources :expenses, only:[:new,:create,:destroy,:update,:edit]
  devise_for :parents
  devise_for :teachers
  devise_for :admins
	root 'welcomes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'admin_index', to: 'admins#index'
  get 'teacher_index', to: 'teachers#index'
  get 'parent_index', to: 'parents#index'
  get '/taska/:id/teachers', to: 'taskas#taska_teachers', as: 'taska_teachers'
  get 'search_expense', to: 'expenses#search'
  get 'search_expense_existing', to: 'expenses#search_existing'
  get 'my_expenses', to: 'expenses#my_expenses'
end
