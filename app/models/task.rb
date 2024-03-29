class Task < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :labels
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
	validates :priority, presence: true
	validates :status, presence: true
	enum priority:[:low, :middle, :high]
	enum status: [:not_started, :in_progress, :completed]
    
	#ソート
	scope :sort_deadline_on, -> { order(:deadline_on) }
	scope :sort_priority, -> { order(priority: :desc, created_at: :desc) }

	#検索
	scope :search, -> (search_params) do
		return if search_params.blank?
			search_title(search_params[:title])
			.search_status(search_params[:status])        
	end

	scope :search_title, ->(title) { where('title LIKE ?', "%#{title}%") if title.present?}
	scope :search_status, ->(status) { where(status: status) if status.present?}
end
