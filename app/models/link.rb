class Link < ActiveRecord::Base
  before_save :save_link_thumbnail

private
  def save_link_thumbnail
    #set the default image
    self.thumbnail_url = "missing_img.jpg"

    link = LinkThumbnailer.generate(self.url)
    return unless url = link.images.first.src.to_s
    self.thumbnail_url = url if link_is_valid?(url)
  end

  def link_is_valid?(url)
    bad_codes = [403, 404]
    response = HTTParty.get(url)
    !bad_codes.include?(response.code)
  end
end
