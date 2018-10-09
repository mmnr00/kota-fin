Rails.application.routes.draw do
  resources :taskas
  resources :expenses, only:[:create,:destroy,:update,:edit]
  resources :classrooms, only:[:show]
  #resources :taska_teachers, only:[:create,:destroy]
  devise_for :parents
  devise_for :teachers
  devise_for :admins
	root 'welcomes#index'
  # For dtails on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'admin_index', to: 'admins#index'
  get 'teacher_index', to: 'teachers#index'
  get 'parent_index', to: 'parents#index'
  get '/taska/:id/teachers', to: 'taskas#taskateachers', as: 'taskateachers'
  get '/taska/:id/expenses_search', to: 'expenses#search', as: 'search_expense'
  get '/taska/:id/expenses', to: 'expenses#my_expenses', as: 'my_expenses'
  get '/taska/:id/expenses/new', to: 'expenses#new', as: 'new_expense'
  get '/taska/:id/search_teacher', to: 'teachers#search', as: 'search_teacher'
  get '/taska/:id/find_teacher', to: 'teachers#find', as: 'find_teacher'
  post '/taska/:id/add_teacher', to: 'taska_teachers#create', as: 'add_teacher'
  delete '/taska/:id/delete_teacher', to: 'taska_teachers#destroy', as: 'delete_teacher'
  get '/taska/:id/classroom', to: 'taskas#classrooms_index', as: 'classroom_index'
  get '/classrooms/:id/teachers', to: 'classrooms#taskateachers_classroom', as: 'list_teacher_classroom'
  post '/classrooms/:id/add_teachers', to: 'teachers_classrooms#create', as: 'add_teacher_classroom'

  
end
