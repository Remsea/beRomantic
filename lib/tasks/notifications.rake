namespace :notifications do
  task send: :environment do
    today = Date.current.to_formatted_s(:short)
    User.where.not(subscription: nil).each do |user|
      user.key_dates.each do |date|
        date.date
        if date.date.to_formatted_s(:short) == today
          user.send_notif(date.description)
        end
      end
    end
  end
end
