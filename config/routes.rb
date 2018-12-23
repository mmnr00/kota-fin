Rails.application.routes.draw do
  
  #devise_for :college_admins
  resources :taskas
  resources :expenses, only:[:create,:destroy,:update,:edit]
  resources :courses, only:[:create,:destroy,:update,:edit]
  resources :colleges, only:[:create,:destroy,:update,:edit]
  resources :classrooms, only:[:new, :create,:destroy,:update,:edit,:show]
  resources :kids, only:[:show,:create,:destroy,:update,:edit]
  resources :payments, only:[:create,:destroy]
  resources :fotos, only:[:edit, :update ,:destroy]
  resources :tchdetails, only:[:show, :new, :create, :destroy, :update, :edit]
  resources :prntdetails, only:[:show, :new, :create, :destroy, :update, :edit]
  resources :ptnssps, only:[:update, :edit]
  #resources :teachers, only:[:show]
  #resources :taska_teachers, only:[:create,:destroy]
  devise_for :parents
  devise_for :teachers #, :controllers=> {:registrations=>"registrations"}
  devise_for :admins
  devise_for :owners#, :controllers => { :passwords => 'passwords' }
	root 'welcomes#index2'


  # For dtails on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   #WELCOME
  get 'login', to: 'welcomes#login'
  get 'sb_dashboard', to: 'welcomes#sb_dashboard'
  get 'sb_table', to: 'welcomes#sb_table'
  get 'star_rating', to: 'welcomes#star_rating'

  #PAGES
  get '/443322/about', to: 'pages#about'
  get '/443322/buttons', to: 'pages#buttons'
  get '/443322/charts', to: 'pages#charts'
  get '/443322/icons', to: 'pages#icons'
  get '/443322/invoice', to: 'pages#invoice'
  get '/443322/dashboard_v1', to: 'pages#dashboard_v1'
  get '/443322/tables', to: 'pages#tables'
  get '/443322/bs_profile', to: 'pages#bs_profile'
  get '/443322/profile_card', to: 'pages#profile_card'
  get '/443322/profile_card_edit', to: 'pages#profile_card_edit'
  get '/443322/pricing', to: 'pages#pricing'
  get '/443322/admin_card', to: 'pages#admin_card'
  get '/443322/classroom_card', to: 'pages#classroom_card'


  get '/443322/bank_status', to: 'pages#bank_status', as: 'bank_status'
  get '/billplz_reg', to: 'pages#billplz_reg'
  get '/443322/team_cards', to: 'pages#team_cards', as: 'team_cards'
  get '/ptns_sp', to: 'pages#ptns_sp'
  post '/ptns_sp_reg', to: 'pages#ptns_sp_reg'
  get '/ptns_sp_list', to: 'pages#ptns_sp_list'
  get '/ptns_sp/:id/update', to: 'pages#ptns_sp_update'
  get '/ptns_sp/:id/patch', to: 'pages#ptns_sp_patch'


  #PDF
  get 'print_payment_course', to: 'pdfs#print_payment_course'

  #ADMINS
  get 'admin_index', to: 'admins#index'
  get 'webarch', to: 'admins#webarch'
  get 'webarchv2', to: 'admins#webarchv2'

  #TCHDETAIL
  get '/print/profile', to: 'tchdetails#show_pdf', as: 'print_profile'


  #OWNERS (FOR COLLEGE)
  get 'owner_index', to: 'owners#index'

  #COLLEGES
  get '/owner/:id/colleges/new', to: 'colleges#new', as: 'new_college'
  get '/owner/:id/colleges/show', to: 'colleges#show_owner', as: 'show_owner'
  get '/teacher/:id/colleges/show', to: 'colleges#show_teacher', as: 'show_teacher'

  #COURSE
  get '/college/:id/courses/new', to: 'courses#new', as: 'new_course'
  get '/teacher/:id/courses/show', to: 'courses#teacher_course', as: 'teacher_course'
  get '/owner/:id/courses/show', to: 'courses#owner_course', as: 'owner_course'
  get '/course/payment', to: 'courses#payment', as: 'course_payment'
  get '/course/payment_pdf', to: 'courses#payment_pdf', as: 'course_payment_pdf'

  #TEACHERS
  get 'teacher_index', to: 'teachers#index'
  get '/taska/:id/search_teacher', to: 'teachers#search', as: 'search_teacher'
  get '/taska/:id/find_teacher', to: 'teachers#find', as: 'find_teacher'
  get '/teacher/:id/my_college', to: 'teachers#college', as: 'teacher_college'
  post '/teacher/:id/add_college', to: 'teachers#add_college', as: 'add_college'
  post '/teacher/:id/remove_college', to: 'teachers#remove_college', as: 'remove_college'
  get '/teacher/:id/payment_signup', to: 'teachers#payment_signup', as: 'payment_signup'
  get '/teacher/:id/teacher_pay_bill', to: 'teachers#teacher_pay_bill', as: 'teacher_pay_bill'

  #PARENTS
  get 'parent_index', to: 'parents#index', as: 'parent_index'
  get '/parent/:id/my_kid', to: 'parents#my_kid', as: 'my_kid'
  get '/parent/:id/view_receipt', to: 'parents#view_receipt', as: 'view_receipt'
  get '/parent/:id/individual_bill', to: 'parents#individual_bill', as: 'parents_individual_bill'
  get '/parent/:id/pay_bill', to: 'parents#parents_pay_bill', as: 'parents_pay_bill'
  get '/parent/:id/feedback', to: 'parents#parents_feedback', as: 'parents_feedback'
  get '/parent/:id/all_bills', to: 'parents#all_bills', as: 'all_bills'

  #TASKAS
  get '/taska/:id/teachers', to: 'taskas#taskateachers', as: 'taskateachers'
  get '/taska/:id/classroom', to: 'taskas#classrooms_index', as: 'classroom_index'
  get '/taska/:id/children', to: 'taskas#children_index', as: 'children_index'
  get '/index_parent', to: 'taskas#index_parent', as: 'index_parent'
  get '/taska_pricing', to: 'taskas#taska_pricing', as: 'taska_pricing'
  get '/remove_taska', to: 'taskas#remove_taska', as: 'remove_taska'
  get '/taska/:id/child_bill_index', to: 'taskas#child_bill_index', as: 'child_bill_index'
  get 'register/:id/center/', to: 'taskas#taska_page', as: 'taska_page'
  get '/taska/:id/update_bank', to: 'taskas#update_bank', as: 'update_bank'
  get '/taska/:id/unpaid_index', to: 'taskas#unpaid_index', as: 'unpaid_index'
  get '/taska/receipts/:id/', to: 'taskas#taska_receipts', as: 'taska_receipts'
  get '/taska/unreg_kids/:id/', to: 'taskas#unreg_kids', as: 'unreg_kids'
  get '/taska/:id/all_bills', to: 'taskas#all_bills', as: 'all_bills_taska'
  get '/taska/:id/xls', to: 'taskas#childlist_xls', as: 'childlist_xls' 
  get '/find_child', to: 'taskas#find_child', as: 'find_child'
  #EXPENSES
  get '/taska/:id/expenses_search', to: 'expenses#search', as: 'search_expense'
  get '/taska/:id/expenses', to: 'expenses#my_expenses', as: 'my_expenses'
  get '/taska/:id/expenses/new', to: 'expenses#new', as: 'new_expense'
  get '/taska/:id/expenses/month_expense', to: 'expenses#month_expense', as: 'month_expense'
  #KIDS
  get '/register_child', to: 'kids#new', as: 'new_kid'
  get '/classroom/:id/search_kid', to: 'kids#search', as: 'search_kid'
  get '/find_kid', to: 'kids#find', as: 'find_kid'
  get 'add_classroom', to: 'kids#add_classroom'
  get 'remove_classroom', to: 'kids#remove_classroom'
  get '/print/kid_pdf', to: 'kids#kid_pdf', as: 'kid_profile'
  post '/add_taska', to: 'kids#add_taska'
  get '/bill_view', to: 'kids#bill_view'
  get '/bill_pdf', to: 'kids#bill_pdf'
  get '/bill_pdf_booking', to: 'kids#bill_pdf_booking'
  get '/remove_siblings', to: 'kids#remove_siblings'
  #TASKA_TEACHERS
  post '/taska/:id/add_teacher', to: 'taska_teachers#create', as: 'add_teacher'
  delete '/taska/:id/delete_teacher', to: 'taska_teachers#destroy', as: 'delete_teacher'
  #CLASSROOMS
  get '/classroom/:id/teachers', to: 'classrooms#taskateachers_classroom', as: 'list_teacher_classroom'
  #TEACHERS_CLASSROOMS
  post '/classrooms/:id/add_teachers', to: 'teachers_classrooms#create', as: 'add_teacher_classroom'
  delete '/classrooms/:id/delete_teachers', to: 'teachers_classrooms#destroy', as: 'delete_teacher_classroom'
  get '/classrooms/:id/xls', to: 'classrooms#classroom_xls', as: 'classroom_xls' 

  #payments
  get '/taska/:id/payment_index', to: 'payments#index', as: 'payment_index'
  get '/taska/:id/create_collection', to: 'payments#create_collection', as: 'create_collection'
  get '/owner/:id/create_collection_college', to: 'payments#create_collection_college', as: 'create_collection_college'
  get '/view_invoice', to: 'payments#view_invoice', as: 'view_invoice'
  get '/create_bill_taska', to: 'payments#create_bill_taska', as: 'create_bill_taska'
  get '/view_invoice_taska', to: 'payments#view_invoice_taska', as: 'view_invoice_taska'
  get '/pdf_invoice_taska', to: 'payments#pdf_invoice_taska', as: 'pdf_invoice_taska'
  get '/create_billplz_bank', to: 'payments#create_billplz_bank'
  get '/update_billplz_bank', to: 'payments#update_billplz_bank'
  get '/create_bill_booking', to: 'payments#create_bill_booking', as: 'create_bill_booking'
  get '/create_billplz_try', to: 'payments#create_billplz_try'

  #get '/taska/:id/create_bill', to: 'payments#create_bill', as: 'create_bill'
  get '/taska/:id/search_bill', to: 'payments#search_bill', as: 'search_bill'
  get '/taska/:id/new_bill', to: 'payments#new', as: 'new_bill'
  get '/taska/:id/view_bill', to: 'payments#view_bill', as: 'view_bill'
  get '/payments/update', to: 'payments#update', as: 'payment_update'
  post '/teacher/:id/new_bill', to: 'payments#teacher_create_bill', as: 'teacher_create_bill'



  
end
