class Job < ApplicationRecord
  searchkick word_start: [:title, :skills] # Elasticsearch hook

  belongs_to :company
  has_many :applications, dependent: :destroy

  validates :title, :description, :location, presence: true

  # For Searchkick to index specific data
  def search_data
    {
      title: title,
      description: description,
      location: location,
      salary_min: salary_min,
      salary_max: salary_max,
      company_name: company.name,
      created_at: created_at
    }
  end
end