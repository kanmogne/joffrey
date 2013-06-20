module Topbar{
	
	function html(){
		 <a class=brand href="./index.html">paf</> <+>
		 
		user_menu()
	}

	signinup_btn =
    <ul class="nav pull-right">
		<li>
			<a data-toggle=modal href="#{Signin.window_id}">Sign in</a>
		</li>
	</ul>

  function user_menu() {
    match (User.get_logged_user()) {

   		case {guest}:
      		signinup_btn

    	case ~{user}:
      		user_box(user.username)
    }
  }

  		private function user_box(username) {
    		id = Dom.fresh_id()
    			<ul id={id} class="nav pull-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">
							{username}
							<b class="caret"></b>
						</a>

				<ul class=dropdown-menu>
					<li><a onclick={logout} href="#">Sign out</a></li>
						</ul>
				</>
			</>
  }

  		private function logout(_) {
    			User.logout();
    				Client.reload()
  }
}