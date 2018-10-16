Rails.application.routes.draw do
  resources :taskas
  resources :expenses, only:[:create,:destroy,:update,:edit]
  resources :classrooms, only:[:show]
  resources :kids, only:[:create,:destroy,:update,:edit]
  #resources :taska_teachers, only:[:create,:destroy]
  devise_for :parents
  devise_for :teachers
  devise_for :admins
	root 'welcomes#index'
  # For dtails on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #ADMINS
  get 'admin_index', to: 'admins#index'
  #TEACHERS
  get 'teacher_index', to: 'teachers#index'
  get '/taska/:id/search_teacher', to: 'teachers#search', as: 'search_teacher'
  get '/taska/:id/find_teacher', to: 'teachers#find', as: 'find_teacher'
  #PARENTS
  get 'parent_index', to: 'parents#index'
  #TASKAS
  get '/taska/:id/teachers', to: 'taskas#taskateachers', as: 'taskateachers'
  get '/taska/:id/classroom', to: 'taskas#classrooms_index', as: 'classroom_index'
  get '/taska/:id/children', to: 'taskas#children_index', as: 'children_index'
  #EXPENSES
  get '/taska/:id/expenses_search', to: 'expenses#search', as: 'search_expense'
  get '/taska/:id/expenses', to: 'expenses#my_expenses', as: 'my_expenses'
  get '/taska/:id/expenses/new', to: 'expenses#new', as: 'new_expense'
  #KIDS
  get '/parent/:id/kids/new', to: 'kids#new', as: 'new_kid'
  get '/classroom/:id/search_kid', to: 'kids#search', as: 'search_kid'
  get '/classroom/:id/find_kid', to: 'kids#find', as: 'find_kid'
  get 'add_classroom', to: 'kids#add_classroom'
  get 'remove_classroom', to: 'kids#remove_classroom'
  #TASKA_TEACHERS
  post '/taska/:id/add_teacher', to: 'taska_teachers#create', as: 'add_teacher'
  delete '/taska/:id/delete_teacher', to: 'taska_teachers#destroy', as: 'delete_teacher'
  #CLASSROOMS
  get '/classroom/:id/teachers', to: 'classrooms#taskateachers_classroom', as: 'list_teacher_classroom'
  #TEACHERS_CLASSROOMS
  post '/classrooms/:id/add_teachers', to: 'teachers_classrooms#create', as: 'add_teacher_classroom'
  
  

  
end
