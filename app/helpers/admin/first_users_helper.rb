module Admin::FirstUsersHelper
  def invite_form?(invite)
    if invite == "true"
      "border border-gray-300 rounded-lg p-3 text-md w-full bg-gray-100 text-gray-500 cursor-not-allowed focus:outline-none focus:ring-0"
    else
      "border border-gray-300 rounded-lg p-3 text-md w-full focus:outline-none focus:ring-2 focus:ring-primary"
    end
  end
end
