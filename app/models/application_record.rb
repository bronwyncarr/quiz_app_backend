# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  self.abstract_class = true
  # the cleanest way i could think of to get the names for facilities from the join table
  def get_facilities(location)
    facilities = []
    location.location_facilities.each do |fac|
      facilities << fac.facility.name
    end

    facilities
  end

  def get_image_url
    url_for(image)
  end

  def image_check(location)
    if location.reviews.any?
      location.reviews.map do |review|
        review.image.attached? ? review.get_image_url : nil
      end

    end
  end

  # Makes the JSON request easier to work with on the React side this is called on the Location object before transmitting it to extract details relating to the location so instead of say having user come through as an integer it comes through with the string
  def transform_json
    facility_array = get_facilities(self)
    {
      id: id,
      location_type_name: location_type.name,
      name: name,
      address: address,
      description: description,
      longitude: longitude,
      latitude: latitude,
      posted: created_at,
      edited: updated_at,
      reviews: reviews,
      faved: false,
      location_facilities_attributes: facility_array,
      google: Rails.application.credentials.dig(:google_maps, :api_key),
      image_url: image_check(self)
    }
  end
end
