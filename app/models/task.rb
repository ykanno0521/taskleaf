class Task < ApplicationRecord
  # validates :name, presence: true
  # validates :name, lengthi: { maximum: 30}
  validates :name, presence: true, length: { maximum: 30}
  validate :validate_name_not_including_comma

  # 一つのタスクに一つの画像を紐づける
  has_one_attached :image

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  # 検索条件を絞る
  def self.ransackable_attrbutes(auth_object = nil) # 検索対象のカラムを指定
    %w[name created_at]
  end

  def self.ransackable_associations(auth_object = nil) # 空の配列を返すことで、意図しない関連を含めないようにする
    []
  end

  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{|attr| task.send(attr)}
      end
    end
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

end
