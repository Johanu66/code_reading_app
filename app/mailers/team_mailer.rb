class TeamMailer < ApplicationMailer
    def team_mail(email)
        @email = email
        mail to: @email, subject: "Transfer of authority"
    end

    def agenda_deleted_mail(email)
        @email = email
        mail to: @email, subject: "An agenda is deleted"
    end
end
