class TeamMailer < ApplicationMailer
    def team_mail(email)
        @email = email
        mail to: @email, subject: "Transfer of authority"
    end
end
