namespace :banners do
  task populate: :environment do
    file_path = Rails.root.join('db/seeds/data/banners.csv')
    headers = [:link, :image_path]

    ActiveRecord::Base.transaction do
      CSV.foreach(file_path, headers: headers) do |banner|
        Banner.create!(link: banner[:link],
                       image_path: "adverts/#{banner[:image_path]}")
      end
    end
  end
end
