class User < ActiveRecord::Base
include Clearance::User
	has_many :books
	has_many :sent_messages, :foreign_key => :sender_id, :class_name => "Message"
	has_many :received_messages, :foreign_key => :receiver_id, :class_name => "Message"
	has_many :notifications

	def messages
		Message.where("sender_id == ? or receiver_id == ?", self.id, self.id)
	end

	def conversations
		other_users = messages.map {|m| m.other_user(self).id}.compact.uniq
		other_users.map { |u| conversation(u).last}.sort {|a,b| b.created_at <=> a.created_at}
	end

	def conversation(user_id)
		Message.where("sender_id == ? and receiver_id == ? or sender_id == ? and receiver_id == ?", self.id, user_id, user_id, self.id)
	end

	def notifications_with(user_id)
		notifs = conversation(user_id).map(&:notification).compact
		notifs.keep_if {|n| n.user_id == self.id}
	end
end
