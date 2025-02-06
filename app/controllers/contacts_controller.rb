class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Load your existing contacts
    @contacts = current_user.contacts.includes(:contact)
    # List potential contacts – users who are not yourself and not already added.
    contact_ids = current_user.contacts.pluck(:contact_id)
    @potential_contacts = User.where.not(id: current_user.id)
                              .where.not(id: contact_ids)
  end

  def create
    # Expect a parameter contact_id which is the user to be added as a contact.
    if params[:contact_id].present? && params[:contact_id].to_i != current_user.id
      @contact = current_user.contacts.build(contact_id: params[:contact_id])
      if @contact.save
        redirect_to contacts_path, notice: "Contact added successfully."
      else
        redirect_to contacts_path, alert: "Failed to add contact."
      end
    else
      redirect_to contacts_path, alert: "Invalid contact."
    end
  end

  def destroy
    @contact = current_user.contacts.find(params[:id])
    @contact.destroy
    redirect_to contacts_path, notice: "Contact removed."
  end
end

