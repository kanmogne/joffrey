module View {

   // View code goes here

  function page_template(title, content, notice) {
    html =
      <div class="navbar navbar-fixed-top">
        <div class=navbar-inner>
          <div class=container>
            {Topbar.html()}
          </div>
        </div>
      </div>

      <div id=#main class=container-fluid>
        <span id=#notice class=container>{notice}</span>
        {content}
        {Signin.modal_window_html()}
        {Signup.modal_wind()}
        
      </div>
    Resource.page(title, html)
  }
 
page_content =

      <div class=hero-unit>
          <h1>Birdy</h1>
            <h2>Micro-blogging platform.<br/>
              Built with <a href="http://opalang.org">Opa.</a>
                </h2>
                  <p>{Signup.signup_btn_html}</p>
                    </div>


    function main_page() {
        page_template("Birdy", page_content, <></>)

      }

    function alert(message, cl){

        <div class ="alert alert-{cl}">
           <button type="button" class="close" data-dismiss="alert">×</button>
                {message}
                  </div>
    }
    
}
