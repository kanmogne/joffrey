module Controller {

  // URL dispatcher of your application; add URL handling as needed

  function dispatcher(Uri.relative url){
    match(url) {
      case { path: ["activation", activation_code]...}:
        Signup.activate_user(activation_code)
      default:
        View.main_page()
    }
    
  }

}

resources = @static_resource_directory("resources")

Server.start(Server.http, [
  { register:
    [ { doctype: { html5 } },
      { js: [ ] },
      { css: [ "/resources/css/style.css"] }
    ]
  },
  { ~resources },
    {dispatch: Controller.dispatcher}
])
