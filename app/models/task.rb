class Task < ApplicationRecord
    validates :title, presence: {message: "can't be blank"}
    validates :content, presence: {message: "can't be blank"}
end
