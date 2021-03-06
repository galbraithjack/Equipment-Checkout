class Request < ActiveRecord::Base
  has_many :passive_sign_outs, class_name: "SignOut",
                foreign_key: "request_id",
                dependent:  :destroy
  has_many :signed_out_by, through: :passive_sign_outs, source: :admin
  has_many :passive_sign_ins, class_name: "SignIn",
                foreign_key: "request_id",
                dependent:  :destroy
  has_many :signed_in_by, through: :passive_sign_ins, source: :admin
  belongs_to :equipment
  before_save { self.email.downcase! }
  default_scope -> { order(created_at: :desc) }
  VALID_NAME_REGEX = /\A[\p{L}\s'.-]+\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_SID_REGEX = /\A(907)+(\d{6})\z/

  validates :equipment_id, presence: true
  validates :name, presence: true,
					length: { maximum: 100 },
					format: { with: VALID_NAME_REGEX }
  validates :email, presence: true,
					length: { maximum: 100 },
					format: { with: VALID_EMAIL_REGEX }
	validates :sid, presence: true,
					length: { minimum: 9, maximum: 9},
					format: { with: VALID_SID_REGEX }

  def signed_out?
    passive_sign_outs.count > 0
  end

  def signed_in?
    passive_sign_ins.count > 0
  end
end
