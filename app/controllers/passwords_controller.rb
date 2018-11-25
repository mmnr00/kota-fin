class PasswordsController < Devise::PasswordsController
	prepend_before_action :require_no_authentication, except: [:edit, :update]
	append_before_action :assert_reset_token_passed, except: [:edit, :update]

end