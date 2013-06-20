module Signup {
		
winId = "signup"

	
		private client function signup(_){

				email = Field.get_value(fld_email) ? error("Cannot read form email")
					username = Field.get_value(fld_username) ? error("Cannot read form name")
						passwd = Field.get_value(fld_passwd) ? error("Cannot read form passwd")
							Modal.hide(#{winId})
								new_user = ~{email, username, passwd}
									#notice =
										match (User.register(new_user)) {
											case {success: _}:
												View.alert("Congratulations! You are successfully registered. You will
													receive an email with account activation instructions shortly.", "success")
											case {failure: msg}:
												View.alert("Your registration failed: {msg}", "error")
										}
	}


		function modal_wind() {

		form = Form.make(signup, {})
		fld = Field.render(form, _)

			form_body =
						<>
							{fld(fld_username)}
								{fld(fld_email)}
									{fld(fld_passwd)}
										{fld(fld_passwd2)}
											</>

				win_body = Form.render(form, form_body)
						win_footer =
								<a href="#" class="btn btn-primary btn-large" onclick={Form.submit_action(form)}> Sign up </a>

									Modal.make(winId, <>New to Birdy?</>, win_body, win_footer, Modal.default_options)
	}

		signup_btn_html =
			<a class="btn btn-large btn-primary" data-toggle=modal href="#{winId}">
					Sign up
							</a>


		function activate_user(activation_code) {
    		notice =
      			match (User.activate_account(activation_code)) {
      				case {success: _}:
        				View.alert("Your account is activated now.", "success") <+>
        					<div class="hero-unit">
								<div class="well form-wrap">
									{Signin.form()}
										</div>
											</div>
      				case {failure: _}:
       						View.alert("Activation code is invalid.", "error") <+>
       							 View.page_content
    	  }

    				View.page_template("Account activation", <></>, notice)
  	}



		private fld_username =
			Field.text_field({Field.new with
				label: "Username",
				required: {with_msg: <>Please enter your username.</>},
			hint: <>Username is publicly visible. You will use it to sign in.</>
})

		private fld_email =
			Field.email_field({Field.new with
				label: "Email",
				required: {with_msg: <>Please enter a valid email address.</>},
				hint: <>Your activation link will be sent to this address.</>
})

		private fld_passwd =
			Field.passwd_field({Field.new with
				label: "Password",
				required: {with_msg: <>Please enter your password.</>},
				hint: <>Password should be at least 6 characters long.</>,
				//validator: {passwd: Field.default_passwd_validator}
})

		private fld_passwd2 =
			Field.passwd_field({Field.new with
				label: "Repeat password",
				required: {with_msg: <>Please repeat your password.</>},
				validator: {equals: fld_passwd, err_msg: <>Your passwords do not match.</>}
})




}
		
