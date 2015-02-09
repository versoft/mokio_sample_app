class Frontend::ContactsController < Frontend::BaseController
  
  def mail
    raise params.inspect
    mailer = Mokio::Mailer.new(mailer_params)
    
    if mailer.valid?
      content  = @menu.contents.first

      mailer.template = content.contact_template.tpl

      ContactMailer.msg(mailer, content.recipient_emails).deliver
      flash[:notice] = t("mail_sent")
    else
      flash[:notice] = t("mail_not_sent")
    end

    respond_to do |format|
      format.js
    end
  end
  
  private
    def mailer_params
      params[:mailer].permit(:name, :email, :message, :title)
    end
  
end