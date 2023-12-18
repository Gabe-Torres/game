require "application_system_test_case"

class SignUpPlayInviteTeammatesTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit sign_up_play_invite_teammates_url
  #
  #   assert_selector "h1", text: "SignUpPlayInviteTeammate"
  # end
  test "a new user can sign up, setup a player, play, and invite a new teammate" do
    # Create a new user
    visit root_url
    email = "jesse@domath.io"
    fill_in "email", with: email
    click_on "Send Login Link"

    assert_text("We've sent a login link to #{email}. Please check your email.")
    assert_text("We just sent an email to #{email} (no gaurantees 😉) with a link that will log you in!")

    user = User.last
    assert_equal(email, user.email)
    assert_nil(user.last_sign_in_at)
    assert(user.team_id)

    token = user.generate_token_for(:magic_link)
    visit login_path(token: token)
    assert_text("Logout")

    # Create a new player
    name = "Jesse"
    click_on "Add player"
    fill_in "Name", with: name
    click_on "Submit"

    player = Player.last
    assert_equal(name, player.name)
    assert_equal(user.team, player.team)

    assert_text("Jesse's progress")

    # Play a game
    click_link "1 + 1"
    within("h3") do
      click_link "1 + 1"
    end
    click_button "2"
    click_button "☑"

    # Check score
    click_on "Jesse's scores"
    assert_text("1\nproblems solved")
    assert_text("1\nday in a row")

    # Invite a teammate
    teammate_email = "jessica@domath.io"
    click_on "Settings"
    click_on "Invite teammate"
    # TODO implement this:
    # fill_in "Email", with: teammate_email
    # click_on "Send invite"

    # assert_text("We've sent an invite to #{teammate_email}.")
    # team = user.team
    # assert_equal(2, team.users.count)

    # click_on "Logout"

    # Accept an invite
    # token = user.generate_token_for(:invite_link)
    # visit invite_path(token: token)
    # assert_text("Logout")
    # assert_text("Players")
    # assert_text("Jesse")

    # take_screenshot
  end
end
