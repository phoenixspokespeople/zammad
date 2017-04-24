module AccessesTickets
  extend ActiveSupport::Concern

  private

  def ticket_permission(ticket, type)
    return true if ticket.permission(current_user: current_user, type: type)
    raise Exceptions::NotAuthorized
  end
end
