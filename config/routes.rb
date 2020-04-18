Rails.application.routes.draw do
  
  #devise_for :college_admins
  resources :taskas, only:[:create,:destroy,:update]
  resources :expenses, only:[:create,:destroy,:update,:edit]
  resources :ptns_mmbs, only:[:create,:destroy,:update,:edit]
  resources :courses, only:[:create,:destroy,:update,:edit]
  resources :colleges, only:[:create,:destroy,:update,:edit]
  resources :classrooms, only:[:create,:destroy,:update]
  resources :kids, only:[:show,:create,:destroy,:update,:edit]
  #resources :payments, only:[:create,:destroy]
  resources :fotos, only:[:edit, :update ,:destroy]
  resources :tchdetails, only:[:show,:create, :destroy, :update, :edit]
  resources :prntdetails, only:[:show, :new, :create, :destroy, :update, :edit]
  resources :ptnssps, only:[:update, :edit]
  resources :extras, only:[:create, :destroy, :update]
  resources :tsklvs, only:[:new, :create, :destroy, :update, :edit]
  #resources :teachers, only:[:show]
  #resources :taska_teachers, only:[:create,:destroy]
  devise_for :parents
  devise_for :teachers #, :controllers=> {:registrations=>"registrations"}
  devise_for :admins
  devise_for :owners#, :controllers => { :passwords => 'passwords' }
	root 'welcomes#index2'


  # For dtails on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   #WELCOME
  get 'cmbr19', to: 'welcomes#cmbr19'
  get 'cmbr19pdf', to: 'welcomes#cmbr19pdf'
  get 'login', to: 'welcomes#login'
  get 'sb_dashboard', to: 'welcomes#sb_dashboard'
  get 'sb_table', to: 'welcomes#sb_table'
  get 'star_rating', to: 'welcomes#star_rating'
  get 'cikgu_anis', to: 'welcomes#cikgu_anis'
  get 'try_bs', to: 'welcomes#try_bs'
  get 'sb2_dashboard', to: 'welcomes#sb2_dashboard'

  #~PTNSMMB
  get '/daftarptns', to: 'ptns_mmbs#new', as: 'new_ptns_mmb'
  #get '/daftarkprm', to: 'ptns_mmbs#new', as: 'new_ptns_mmb'
  get '/find_ptns', to: 'ptns_mmbs#find_ptns', as: 'find_ptns'
  get '/senarai_ahli', to: 'ptns_mmbs#list_ptns', as: 'list_ptns'
  get '/mmb_pdf', to: 'ptns_mmbs#mmb_pdf', as: 'mmb_pdf'
  get '/after_reg_ptns', to: 'ptns_mmbs#after_reg', as: 'after_reg_ptns'
  get '/add_expire', to: 'ptns_mmbs#add_expire'
  get '/add_mmbid', to: 'ptns_mmbs#add_mmbid'
  get '/mmblist_xls', to: 'ptns_mmbs#mmblist_xls'
  get '/reg_event', to: 'ptns_mmbs#reg_event'
  get '/reg_cfm', to: 'ptns_mmbs#reg_cfm'
  get '/reg_list', to: 'ptns_mmbs#reg_list'
  get '/reg_listxls', to: 'ptns_mmbs#reg_listxls'
  get '/regedit/:id', to: 'ptns_mmbs#regedit', as: 'regedit'
  get '/regupd/:id', to: 'ptns_mmbs#regupd'


  #~PAGES
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
  get '/443322/sendgrid', to: 'pages#sendgrid'
  get '/tutorial', to: 'pages#tutorial'
  get '/tryroo', to: 'pages#tryroo'
  post '/uploadroo', to: 'pages#uploadroo', as: 'uploadroo'


  get '/443322/bank_status', to: 'pages#bank_status', as: 'bank_status'
  get '/billplz_reg', to: 'pages#billplz_reg'
  get '/443322/team_cards', to: 'pages#team_cards', as: 'team_cards'
  get '/ptns_sp', to: 'pages#ptns_sp'
  post '/ptns_sp_reg', to: 'pages#ptns_sp_reg'
  get '/ptns_sp_list', to: 'pages#ptns_sp_list'
  get '/ptns_sp/:id/update', to: 'pages#ptns_sp_update'
  get '/ptns_sp/:id/patch', to: 'pages#ptns_sp_patch'
  get '/sms', to: 'pages#sms'

  #~EXTRAS
  get 'new_ajk', to: 'extras#new', as: 'new_ajk'
  get 'edit_ajk', to: 'extras#edit', as: 'edit_ajk'
  get 'reset_ajk', to: 'extras#reset_ajk', as: 'reset_ajk'

  #OLD EXTRA
  get 'add_kid_extras', to: 'extras#add_kid_extras'
  get 'remove_kid_extras', to: 'extras#remove_kid_extras'

  #~OTKIDS
  get 'crt_otkid', to: 'otkids#crt_otkid'
  get 'rmv_otkid', to: 'otkids#rmv_otkid'

  #~ANISATTS
  get 'accept_attendance', to: 'anisatts#accept', as: 'accept_anis'
  get 'remove_attendance', to: 'anisatts#remove', as: 'remove_anis'

  #~ANISPROGRS
  get 'anisprog_new', to: 'anisprogs#anisprog_new', as: 'anisprog_new'
  get 'anisprog_edit', to: 'anisprogs#anisprog_edit', as: 'anisprog_edit'
  get 'anisprog_update', to: 'anisprogs#anisprog_update', as: 'anisprog_update'
  get 'anisprog_remove', to: 'anisprogs#anisprog_remove', as: 'anisprog_remove'

  #~ANISFEEDS
   get 'anisfeed_new', to: 'anisfeeds#anisfeed_new'
   get 'anisfeed_pre', to: 'anisfeeds#anisfeed_pre'
   get 'anisfeed_do', to: 'anisfeeds#anisfeed_do'
   post 'anisfeed_save', to: 'anisfeeds#anisfeed_save'

  #~PDF
  get 'print_payment_course', to: 'pdfs#print_payment_course'

  #~ADMINS
  get 'admin_index_old', to: 'admins#index_old'
  get 'admin_index', to: 'admins#index'
  get 'webarch', to: 'admins#webarch'
  get 'webarchv2', to: 'admins#webarchv2'

  #~TCHDETAIL
  get '/print/profile', to: 'tchdetails#show_pdf', as: 'print_profile'
  get '/newtchdetail', to: 'tchdetails#new', as: 'new_tchdetail'
  get '/find_tchdetail', to: 'tchdetails#find_tchdetail', as: 'find_tchdetail'
  get '/find_tchdetail_reg', to: 'tchdetails#find_tchdetail_reg', as: 'find_tchdetail_reg'
  get '/tchd_anis', to: 'tchdetails#tchd_anis', as: 'tchd_anis'
  get '/tchd_xls', to: 'tchdetails#tchd_xls', as: 'tchd_xls' 
  get '/market_xls', to: 'tchdetails#market_xls', as: 'market_xls'
  get '/dir_anis', to: 'tchdetails#dir_anis'

  #~OWNERS (FOR COLLEGE)
  get 'owner_index', to: 'owners#index'

  #~COLLEGES
  get '/owner/:id/colleges/new', to: 'colleges#new', as: 'new_college'
  get '/owner/:id/colleges/show', to: 'colleges#show_owner', as: 'show_owner'
  get '/teacher/:id/colleges/show', to: 'colleges#show_teacher', as: 'show_teacher'
  post '/assg_clg', to: 'colleges#assg_clg'
  get '/assg_clg_tch', to: 'colleges#assg_clg_tch'
  get '/anis_reglist', to: 'colleges#anis_reglist'
  get '/college/:id/report', to: 'colleges#college_report', as: 'college_report'
  get '/college/:id/report_xls', to: 'colleges#college_reportxls', as: 'college_reportxls'
  post '/college/overall_xls.xlsx', to: 'colleges#overall_reportxls', as: 'overall_reportxls'
  get '/infopage', to: 'colleges#infopage', as: 'infopage_anis'
  get '/crtatt', to: 'colleges#crtatt'
  get 'chsreport', to: 'colleges#chsreport'

  #~COURSE
  get '/courses/new', to: 'courses#new', as: 'new_course'
  get '/teacher/:id/courses/show', to: 'courses#teacher_course', as: 'teacher_course'
  get '/owner/:id/courses/show', to: 'courses#owner_course', as: 'owner_course'
  get '/course/payment', to: 'courses#payment', as: 'course_payment'
  get '/course/payment_pdf', to: 'courses#payment_pdf', as: 'course_payment_pdf'
  get '/course_report', to: 'courses#course_report'
  get '/anisprog_report', to: 'courses#anisprog_report'
  get '/course_reportpdf', to: 'courses#course_reportpdf'
  get '/course/:id/participation', to: 'courses#partc_prog', as: 'partc_prog'

  #~TEACHERS
  get 'teacher_index', to: 'teachers#index'
  get '/taska/:id/search_teacher', to: 'teachers#search', as: 'search_teacher'
  get '/taska/:id/find_teacher', to: 'teachers#find', as: 'find_teacher'
  get '/teacher/:id/my_college', to: 'teachers#college', as: 'teacher_college'
  get '/teacher/:id/my_taska', to: 'teachers#taska', as: 'teacher_taska'
  get '/teacher/:id/my_leave', to: 'teachers#tchleave', as: 'tchleave'
  get '/leave/:id/edit_leave', to: 'teachers#tcheditlv', as: 'tcheditlv'
  post '/teacher/:id/add_college', to: 'teachers#add_college', as: 'add_college'
  post '/teacher/:id/remove_college', to: 'teachers#remove_college', as: 'remove_college'
  get '/teacher/:id/payment_signup', to: 'teachers#payment_signup', as: 'payment_signup'
  get '/teacher/:id/teacher_pay_bill', to: 'teachers#teacher_pay_bill', as: 'teacher_pay_bill'
  get '/add_taska', to: 'teachers#add_taska', as: 'tch_add_taska'
  get '/find_taska', to: 'teachers#find_taska', as: 'tch_find_taska'
  get '/teacher/:id/teacher_payslip', to: 'teachers#tchpslip', as: 'tchpslip'

  #~APPLVS
  post '/apply_leave', to: 'applvs#apply', as: 'tchapplylv'
  patch 'leave/:id/update_leave', to: 'applvs#tchupdate', as: 'tchupdatelv'
  get 'action_leave', to: 'applvs#admupdate', as: 'admupdatelv'
  get 'revert_leave', to: 'applvs#revleave', as: 'revleave'
  delete 'leave/:id/delete_leave', to: 'applvs#tchdelete', as: 'tchdeletelv'

  #~PARENTS
  get 'parent_index', to: 'parents#index', as: 'parent_index'
  get '/parent/:id/my_kid', to: 'parents#my_kid', as: 'my_kid'
  get '/check_kid', to: 'parents#check_kid', as: 'check_kid'
  get '/sch_kid', to: 'parents#sch_kid', as: 'sch_kid'
  get '/mrg_kid', to: 'parents#mrg_kid', as: 'mrg_kid'
  get '/prntschtsk', to: 'parents#prntschtsk', as: 'prntschtsk'
  get '/prntfndtsk', to: 'parents#prntfndtsk', as: 'prntfndtsk'
  get '/parent/:id/view_receipt', to: 'parents#view_receipt', as: 'view_receipt'
  get '/parent/:id/individual_bill', to: 'parents#individual_bill', as: 'parents_individual_bill'
  get '/parent/:id/pay_bill', to: 'parents#parents_pay_bill', as: 'parents_pay_bill'
  get '/parent/:id/feedback', to: 'parents#parents_feedback', as: 'parents_feedback'
  get '/parent/:id/all_bills', to: 'parents#all_bills', as: 'all_bills'

  #~TASKAS
  get '/community/edit/:id', to: 'taskas#edit'
  get '/community/:id', to: 'taskas#show', as: 'taskashow'
  get '/community_ajk/:id', to: 'taskas#tsk_ajk', as: 'tsk_ajk'
  get '/community_fee/:id', to: 'taskas#tsk_fee', as: 'tsk_fee'
  get '/community_financial/:id', to: 'taskas#tsk_financial', as: 'tsk_financial'
  get '/community_vismgmt/:id', to: 'taskas#tsk_vismgmt', as: 'tsk_vismgmt'
  get '/community_activt/:id', to: 'taskas#tsk_activt', as: 'tsk_activt'
  get '/community_newblast/:id', to: 'taskas#tsk_newblast', as: 'tsk_newblast'
  get '/crt_ajk', to: 'taskas#crt_ajk', as: 'crt_ajk'
  get '/dlt_ajk', to: 'taskas#dlt_ajk', as: 'dlt_ajk'
  post '/upd_ajk', to: 'taskas#upd_ajk', as: 'upd_ajk'
  get '/shw_bilitm', to: 'taskas#shw_bilitm', as: 'shw_bilitm'
  post '/upd_bilitm', to: 'taskas#upd_bilitm', as: 'upd_bilitm'
  post '/upld_res', to: 'taskas#upld_res', as: 'upld_res'

  
  ##OLD routes##
  get '/taska/:id/teachers', to: 'taskas#taskateachers', as: 'taskateachers'
  get '/taska/:id/tchinfo_new', to: 'taskas#tchinfo_new', as: 'tchinfo_new'
  get '/taska/:id/tchinfo_save', to: 'taskas#tchinfo_save', as: 'tchinfo_save'
  get '/taska/:id/tchrm_cls', to: 'taskas#tchrm_cls', as: 'tchrm_cls'
  get '/taska/:id/tchinfo_edit', to: 'taskas#tchinfo_edit', as: 'tchinfo_edit'
  get '/taska/:id/tchinfo_update', to: 'taskas#tchinfo_update', as: 'tchinfo_update'
  get '/taska/:id/classroom', to: 'taskas#classrooms_index', as: 'classroom_index'
  get '/taska/:id/children', to: 'taskas#children_index', as: 'children_index'
  get '/index_parent', to: 'taskas#index_parent', as: 'index_parent'
  get '/taska_pricing', to: 'taskas#taska_pricing', as: 'taska_pricing'
  get '/remove_taska', to: 'taskas#remove_taska', as: 'remove_taska'
  get '/taska/:id/child_bill_index', to: 'taskas#child_bill_index', as: 'child_bill_index'
  get 'register/:id/center/', to: 'taskas#taska_page', as: 'taska_page'
  get '/taska/:id/update_bank', to: 'taskas#update_bank', as: 'update_bank'
  get '/taska/:id/unpaid_index', to: 'taskas#unpaid_index', as: 'unpaid_index'
  get '/taska/:id/updunpaid', to: 'taskas#updunpaid', as: 'updunpaid'
  get '/taska/receipts/:id/', to: 'taskas#taska_receipts', as: 'taska_receipts'
  get '/taska/unreg_kids/:id/', to: 'taskas#unreg_kids', as: 'unreg_kids'
  get '/taska/:id/all_bills', to: 'taskas#all_bills', as: 'all_bills_taska'
  get '/taska/:id/xls', to: 'taskas#childlist_xls', as: 'childlist_xls' 
  get '/find_child', to: 'taskas#find_child', as: 'find_child'
  get '/sms_reminder', to: 'taskas#sms_reminder'
  get '/sms_reminder_all', to: 'taskas#sms_reminder_all'
  get '/taska/:id/unpaid_xls', to: 'taskas#unpaid_xls', as: 'unpaid_xls' 
  get '/taska/:id/pl_xls', to: 'taskas#pl_xls', as: 'pl_xls'
  get '/taska/:id/add_subdomain', to: 'taskas#add_subdomain' 
  get '/taska/:id/bill_account', to: 'taskas#bill_account', as: 'bill_account'
  get '/taska/:id/plrpt_xls', to: 'taskas#plrpt_xls', as: 'plrpt_xls'
  get '/taska/:id/tchleave', to: 'taskas#tchleave', as: 'tsk_tchleave'
  get '/taska/:id/tchleave_xls', to: 'taskas#tchleave_xls', as: 'tchleave_xls' 
  get '/taska/:id/tchpayslip', to: 'taskas#tchpayslip', as: 'tchpayslip' 
  get '/taska/:id/chkpayslip', to: 'taskas#chkpayslip', as: 'chkpayslip' 
  get '/taska/:id/newpayslip', to: 'taskas#newpayslip', as: 'newpayslip'
  get '/taska/:id/crtpayslip', to: 'taskas#crtpayslip', as: 'crtpayslip'
  get '/taska/:id/editpayslip', to: 'taskas#editpayslip', as: 'editpayslip'
  get '/taska/:id/updpayslip', to: 'taskas#updpayslip', as: 'updpayslip' 
  get '/taska/:id/chgplan', to: 'taskas#chgplan', as: 'tsk_chgplan' 
  get '/taska/:id/svplan', to: 'taskas#svplan', as: 'tsk_svplan'
  get '/taska/:id/manupdbill', to: 'taskas#manupdbill', as: 'tsk_manupdbill'
  post '/taska/:id/svupdbill', to: 'taskas#svupdbill', as: 'tsk_svupdbill'
  get '/find_spv', to: 'taskas#find_spv', as: 'tsk_find_spv'
  get '/add_role/:id', to: 'taskas#add_role', as: 'tsk_add_role'
  get '/rmv_role/:id', to: 'taskas#rmv_role', as: 'tsk_rmv_role'
  get '/delete_parpym', to: 'taskas#delete_parpaym', as: 'delete_parpaym'
  get '/taska/:id/xlsclsrm', to: 'taskas#xlsclsrm', as: 'xlsclsrm'
  get '/tempclsrmxls', to: 'taskas#tempclsrmxls'
  get '/taska/:id/tempkidxls', to: 'taskas#tempkidxls', as: 'tempkidxls'
  post '/taska/:id/upldclsrm', to: 'taskas#upldclsrm', as: 'upldclsrm'
  get '/taska/:id/xlskid', to: 'taskas#xlskid', as: 'xlskid'
  post '/taska/:id/upldkid', to: 'taskas#upldkid', as: 'upldkid'
  get '/taska/:id/hiscrdt', to: 'taskas#hiscrdt', as: 'hiscrdt'
  get '/taska/:id/topcred', to: 'taskas#topcred', as: 'topcred'

  ## ANSYS19
  get '/rsvpans', to: 'taskas#rsvpans'
  get '/updrsvp', to: 'taskas#updrsvp'
  get '/updrsvpadm', to: 'taskas#updrsvpadm'
  get '/regansys', to: 'taskas#regansys'
  post '/crtansys', to: 'taskas#crtansys'
  get '/statansys', to: 'taskas#statansys'
  get '/editansys', to: 'taskas#editansys'
  patch '/updansys', to: 'taskas#updansys'
  get '/ansys_xls', to: 'taskas#ansys_xls'
  get '/succansys', to: 'taskas#succansys'
  get 'delansys', to: 'taskas#delansys'
  get 'admansys', to: 'taskas#admansys'

  ## MBR 19
  get '/regmbr1987878787', to: 'taskas#regmbr19'
  post '/crtmbr19', to: 'taskas#crtmbr19'
  get '/statmbr19', to: 'taskas#statmbr19'
  get '/editmbr19', to: 'taskas#editmbr19'
  patch '/updmbr19', to: 'taskas#updmbr19'
  get '/mbr19_xls', to: 'taskas#mbr19_xls'


  #~PAYSLIPS
  get 'viewpayslips', to: 'payslips#viewpsl', as: 'viewpsl'
  get 'pdfpayslips', to: 'payslips#pdfpsl', as: 'pdfpsl'
  get 'dltpayslips', to: 'payslips#dltpsl', as: 'dltpsl'

  #~EXPENSES
  get '/taska/:id/expenses_search', to: 'expenses#search', as: 'search_expense'
  get '/taska/:id/my_expenses', to: 'expenses#my_expenses', as: 'my_expenses'
  get '/taska/:id/expenses/new', to: 'expenses#new', as: 'new_expense'
  get '/taska/:id/expenses/month_expense', to: 'expenses#month_expense', as: 'month_expense'
  
  #~KIDS
  get '/register_child_admin', to: 'kids#new_admin', as: 'new_kid_admin'
  get '/register_child', to: 'kids#new', as: 'new_kid'
  get '/classroom/:id/search_kid', to: 'kids#search', as: 'search_kid'
  get '/find_kid', to: 'kids#find', as: 'find_kid'
  get 'add_classroom', to: 'kids#add_classroom'
  get 'remove_classroom', to: 'kids#remove_classroom'
  get '/print/kid_pdf', to: 'kids#kid_pdf', as: 'kid_profile'
  post '/add_taska', to: 'kids#add_taska'
  get '/billview', to: 'kids#billvw'
  get '/bill_view', to: 'kids#bill_view'
  get '/bill_pdf', to: 'kids#bill_pdf'
  get '/bill_pdf_booking', to: 'kids#bill_pdf_booking'
  get '/remove_siblings', to: 'kids#remove_siblings'
  
  #~TASKA_TEACHERS
  post '/taska/:id/add_teacher', to: 'taska_teachers#create', as: 'add_teacher'
  delete '/taska/:id/delete_teacher', to: 'taska_teachers#destroy', as: 'delete_teacher'
  get '/remove_teacher', to: 'taska_teachers#remove_teacher', as: 'remove_teacher'

  #~CLASSROOMS
  post '/upd_vehicle', to: 'classrooms#upd_vehicle', as: 'upd_vehicle'
  delete '/del_vehicle', to: 'classrooms#del_vehicle', as: 'del_vehicle' 
  post '/add_vehicle', to: 'classrooms#add_vehicle', as: 'add_vehicle'
  get '/add_unit', to: 'classrooms#new', as: 'add_unit'
  get '/edit_vehicle', to: 'classrooms#edit_vehicle', as: 'edit_vehicle'
  get '/edit_unit', to: 'classrooms#edit', as: 'edit_unit'
  post '/add_topay', to: 'classrooms#add_topay', as: 'add_topay'
  get '/classroom/:id/teachers', to: 'classrooms#taskateachers_classroom', as: 'list_teacher_classroom'
  
  #~TEACHERS_CLASSROOMS
  post '/classrooms/:id/add_teachers', to: 'teachers_classrooms#create', as: 'add_teacher_classroom'
  delete '/classrooms/:id/delete_teachers', to: 'teachers_classrooms#destroy', as: 'delete_teacher_classroom'
  get '/classrooms/:id/xls', to: 'classrooms#classroom_xls', as: 'classroom_xls' 

  #~payments
  get '/crt_pmt', to: 'payments#crt_pmt', as: 'crt_pmt'
  get '/view_bill', to: 'payments#view_bill', as: 'view_bill'
  get '/list_bill', to: 'payments#list_bill', as: 'list_bill'
  post '/mtl_pmt', to: 'payments#mtl_pmt', as: 'mtl_pmt'
  get '/updall_pmt', to: 'payments#updall_pmt', as: 'updall_pmt'
  get '/man_pmt', to: 'payments#man_pmt', as: 'man_pmt'
  post '/upd_pmt', to: 'payments#upd_pmt', as: 'upd_pmt'
  get '/rev_pmt', to: 'payments#rev_pmt', as: 'rev_pmt'
  get '/del_pmt', to: 'payments#del_pmt', as: 'del_pmt'

  
  ## OLD ##
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
  get '/bill_taska_monthly', to: 'payments#bill_taska_monthly'
  get '/bill_taska1_monthly', to: 'payments#bill_taska1_monthly'
  get '/got_bill', to: 'payments#got_bill'
  get '/chek_bill', to: 'payments#chek_bill'
  get '/tsksvbill', to: 'payments#tsksvbill'
  

  #get '/taska/:id/create_bill', to: 'payments#create_bill', as: 'create_bill'
  get '/taska/:id/search_bill', to: 'payments#search_bill', as: 'search_bill'
  get '/taska/:id/new_bill', to: 'payments#new', as: 'new_bill'
  #get '/taska/:id/edit_bill', to: 'payments#edit_bill', as: 'edit_bill'
  #get '/taska/:id/upd_bill', to: 'payments#upd_bill', as: 'upd_bill'
  
  get '/payments/update', to: 'payments#update', as: 'payment_update'
  post '/teacher/:id/new_bill', to: 'payments#teacher_create_bill', as: 'teacher_create_bill'



  
end
