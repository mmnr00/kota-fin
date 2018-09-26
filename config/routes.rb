Rails.application.routes.draw do
  resources :taskas
  resources :expenses, only:[:create,:destroy,:update,:edit]
  devise_for :parents
  devise_for :teachers
  devise_for :admins
	root 'welcomes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'admin_index', to: 'admins#index'
  get 'teacher_index', to: 'teachers#index'
  get 'parent_index', to: 'parents#index'
  get '/taska/:id/teachers', to: 'taskas#taska_teachers', as: 'taska_teachers'
  get '/taska/:id/expenses_search', to: 'expenses#search', as: 'search_expense'
  get 'search_expense_existing', to: 'expenses#search_existing'
  get '/taska/:id/expenses', to: 'expenses#my_expenses', as: 'my_expenses'
  get '/taska/:id/expenses/new', to: 'expenses#new', as: 'new_expense'
  get '/taska/:id/search_teacher', to: 'teachers#search', as: 'search_teacher'
end
