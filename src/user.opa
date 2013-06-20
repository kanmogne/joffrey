abstract type User.name = string
abstract type User.status = {active} or {string activation_code}

type User.t = { Email.email email, User.name username }
type User.logged = {guest} or {User.t user}

abstract type User.info =
  { Email.email email,
    string username,
    string passwd,
    User.status status
  }

module User {
  private function send_registration_email(args) {
    from = Email.of_string("no-reply@{Model.main_host}")
    subject = "Birdy says welcome"
      email =
        <p>Hello {args.username}!</p>
        <p>Thank you for registering with Birdy.</p>
        <p>Activate your account by clicking on
<a href="http://{Model.main_host}{Model.main_port}/activation/{args.activation_code}">
this link
</a>.
</p>
        <p>Happy messaging!</p>
        <p>--------------</p>
        <p>The Birdy Team</p>
        content = {html: email}
    continuation = function(_) { void }
    SmtpClient.try_send_async(from, args.email, subject, content, Email.default_options, continuation)
  }

  private UserContext.t(User.logged) logged_user = UserContext.make({guest})

  private function User.t mk_view(User.info info) {
    {username: info.username, email: info.email}
  }

  exposed function outcome register(user) {
    activation_code = Random.string(15)
    user =
      { email: user.email,
        username: user.username,
        passwd: user.passwd,
        status: {~activation_code}
      }
    x = ?/paf/users[{username: user.username}]
    match (x) {
    case {none}:
      /paf/users[{username: user.username}] <- user
      send_registration_email({~activation_code, username:user.username, email: user.email})
      {success}
    case {some: _}:
      {failure: "User with the given name already exists."}
    }
  }

  function string get_name(User.t user) {
    user.username
  }

  function User.logged get_logged_user() {
    UserContext.get(logged_user)
  }

  function logout() {
    UserContext.set(logged_user, {guest})
  }

  exposed function outcome activate_account(activation_code) {
    user = /paf/users[status == ~{activation_code}]
           |> DbSet.iterator
           |> Iter.to_list
           |> List.head_opt
    match (user) {
    case {none}:
      {failure}
    case {some: user}:
      /paf/users[{username: user.username}] <- {user with status: {active}}
      {success}
    }
  }

  exposed function outcome(User.t, string) login(username, passwd) {
    x = ?/paf/users[~{username}]
    match (x) {
    case {none}:
      {failure: "This user does not exist."}
    case {some: user}:
      match (user.status) {
      case {activation_code: _}:
        {failure: "You need to activate your account by clicking the link we sent you by email."}
      case {active}:
        if (user.passwd == passwd) {
          user_view = mk_view(user)
          UserContext.set(logged_user, {user: user_view})
          {success: user_view}
        }
        else
          {failure: "Incorrect password. Try again."}
      }
    }
  }
}