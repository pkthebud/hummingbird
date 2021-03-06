class ReviewSerializer < ActiveModel::Serializer
  include ReviewsHelper

  embed :ids

  attributes :id,
             :summary,
             :positive_votes,
             :total_votes,
             :rating,
             :rating_story,
             :rating_animation,
             :rating_sound,
             :rating_characters,
             :rating_enjoyment,
             :content,
             :formatted_content,
             :liked

  has_one :user, embed_key: :name, include: true
  has_one :anime, embed_key: :slug

  def summary
    object.summary || HTML::FullSanitizer.new.sanitize(object.content).truncate(130, separator: ' ', omission: '...')
  end

  def rating
    object.rating / 2.0
  end

  def rating_story
    object.rating_story / 2.0
  end

  def rating_animation
    object.rating_animation / 2.0
  end

  def rating_sound
    object.rating_sound / 2.0
  end

  def rating_characters
    object.rating_character / 2.0
  end

  def rating_enjoyment
    object.rating_enjoyment / 2.0
  end

  def liked
    scope && Vote.for(scope, object).try(:positive?)
  end

  def formatted_content
    if object.source == "mal_import"
      simple_format_review(object.content)
    else
      sanitize_review(object.content)
    end
  end

  def attributes
    hash = super
    hash["user_id"] = object.user.name
    hash
  end
end
