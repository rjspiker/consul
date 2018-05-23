require 'base64'

set :base_url, "https://www.consul.io/"

# Middleware for rendering preact components
use ReshapeMiddleware, component_file: "assets/reshape.js"

activate :hashicorp do |h|
  h.name         = "consul"
  h.version      = "1.1.0"
  h.github_slug  = "hashicorp/consul"
  h.website_root = "website"

  h.releases_enabled = true
end

# compile js with webpack, css with postcss
# activate :external_pipeline,
#   name: 'assets',
#   command: "cd assets && ./node_modules/.bin/spike #{build? ? :compile : :watch}",
#   source: 'assets/public'

# pull site data from datocms
# activate :dato,
#   token: '78d2968c99a076419fbb'

helpers do
  # Encodes dato data as base64-minified JSON for compatibility with reshape
  # components.
  def encode(data)
    res = data.is_a?(Array) ? "[#{data.map { |d| d.to_hash.to_json }.join(',')}]" : data.to_hash.to_json
    Base64.encode64(res).gsub(/\n/, '')
  end

  # Returns a segment tracking ID such that local development is not
  # tracked to production systems.
  def segmentId()
    if (ENV['ENV'] == 'production')
      'IyzLrqXkox5KJ8XL4fo8vTYNGfiKlTCm'
    else
      '0EXTgkNx0Ydje2PGXVbRhpKKoe5wtzcE'
    end
  end

  # Returns the FQDN of the image URL.
  #
  # @param [String] path
  #
  # @return [String]
  def image_url(path)
    File.join(base_url, image_path(path))
  end

  # Get the title for the page.
  #
  # @param [Middleman::Page] page
  #
  # @return [String]
  def title_for(page)
    if page && page.metadata
      return "#{page.metadata[:title]} - Vault by HashiCorp"
    elsif page && page.data.page_title
      return "#{page.data.page_title} - Vault by HashiCorp"
    end

     "Vault by HashiCorp"
  end

  # Get the description for the page
  #
  # @param [Middleman::Page] page
  #
  # @return [String]
  def description_for(page)
    description = (page.data.description || page.metadata[:description] || "Consul by HashiCorp")
      .gsub('"', '')
      .gsub(/\n+/, ' ')
      .squeeze(' ')

    return escape_html(description)
  end

  # This helps by setting the "active" class for sidebar nav elements
  # if the YAML frontmatter matches the expected value.
  def sidebar_current(expected)
    current = current_page.data.sidebar_current || ""
    if current.start_with?(expected)
      return " class=\"active\""
    else
      return ""
    end
  end

  # Returns the id for this page.
  # @return [String]
  def body_id_for(page)
    if !(name = page.data.sidebar_current).blank?
      return "p-#{name.strip}"
    end
    if page.url == "/" || page.url == "/index.html"
      return "p-home"
    end
    if !(title = page.data.page_title || page.metadata[:title]).blank?
      return "p-" + title
        .downcase
        .gsub('"', '')
        .gsub(/[^\w]+/, '-')
        .gsub(/_+/, '-')
        .squeeze('-')
        .squeeze(' ')
    end
    return ""
  end

  # Returns the list of classes for this page.
  # @return [String]
  def body_classes_for(page)
    classes = []

    if !(layout = page.data.layout).blank?
      classes << "layout-#{page.data.layout}"
    end

    if !(title = page.data.page_title).blank?
      title = title
        .downcase
        .gsub('"', '')
        .gsub(/[^\w]+/, '-')
        .gsub(/_+/, '-')
        .squeeze('-')
        .squeeze(' ')
      classes << "page-#{title}"
    end

    return classes.join(" ")
  end
end
