class ContactMailer < ActionMailer::Base

  def msg(obj, recipients)
    @message = obj.template
    @message.gsub!("%name%", obj.name)
    @message.gsub!("%email%", obj.email)
    @message.gsub!("%title%", obj.title)
    @message.gsub!("%message%", obj.message)

    mail(to: recipients, subject: "#{t("contacts.form.title")}: #{obj.title}")
  end
  
end

