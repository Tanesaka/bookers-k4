class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

# フォロー機能記載

  # foreign_key（FK）には、@user.xxxとした際に「@user.idがfollower_idなのかfollowed_idなのか」を指定します
  # フォローしている人　として定義。
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # @user.booksのように、@user.yyyで、そのユーザがフォローしている人の一覧を出したい
  has_many :following, through: :relationships, source: :follower

# followedの分の記載　フォローされている人　として定義
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # そのユーザーがフォローされている人の一覧
  has_many :befollowed, through: :relationships, source: :followed


# 12/4 find_byの後はforeign_keyと同じになると予想
  def following?(other_user)
    following_relationships.find_by(follower_id: other_user.id)
  end

  def follow!(other_user)
    following_relationships.create!(follower_id: other_user.id)
  end

  def unfollow!(other_user)
    following_relationships.find_by(follower_id: other_user.id).destroy
  end

  # ここまで

  attachment :profile_image, destroy: false

  validates :name, uniqueness: true, presence: true, length: { minimum: 2 , maximum: 20 }
  validates :introduction, length: { maximum: 50 }
end
