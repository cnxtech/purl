class IiifV3Controller < ApplicationController
  before_action :load_purl

  rescue_from PurlResource::DruidNotValid, with: :invalid_druid
  rescue_from PurlResource::ObjectNotReady, with: :object_not_ready

  def manifest
    return unless stale?(last_modified: @purl.updated_at.utc, etag: @purl.cache_key + "/#{@purl.updated_at.utc}")

    manifest = Rails.cache.fetch([@purl, @purl.updated_at.utc, 'iiif_v3', 'manifest'], expires_in: Settings.resource_cache.lifetime) do
      @purl.iiif3_manifest.body(self).to_ordered_hash
    end

    render json: JSON.pretty_generate(manifest.as_json)
  end

  def canvas
    return unless stale?(last_modified: @purl.updated_at.utc, etag: @purl.cache_key + "/#{@purl.updated_at.utc}")

    manifest = Rails.cache.fetch([@purl, @purl.updated_at.utc, 'iiif_v3', 'canvas'], expires_in: Settings.resource_cache.lifetime) do
      @purl.iiif3_manifest.canvas(controller: self, resource_id: params[:resource_id]).try(:to_ordered_hash)
    end

    if manifest
      render json: JSON.pretty_generate(manifest.as_json)
    else
      head :not_found
    end
  end

  def annotation_page
    return unless stale?(last_modified: @purl.updated_at.utc, etag: @purl.cache_key + "/#{@purl.updated_at.utc}")

    manifest = Rails.cache.fetch([@purl, @purl.updated_at.utc, 'iiif_v3', 'annotation_page'], expires_in: Settings.resource_cache.lifetime) do
      @purl.iiif3_manifest.annotation_page(controller: self, annotation_page_id: params[:annotation_page_id]).try(:to_ordered_hash)
    end

    if manifest
      render json: JSON.pretty_generate(manifest.as_json)
    else
      head :not_found
    end
  end

  def annotation
    return unless stale?(last_modified: @purl.updated_at.utc, etag: @purl.cache_key + "/#{@purl.updated_at.utc}")

    manifest = Rails.cache.fetch([@purl, @purl.updated_at.utc, 'iiif_v3', 'annotation'], expires_in: Settings.resource_cache.lifetime) do
      @purl.iiif3_manifest.annotation(controller: self, annotation_id: params[:annotation_id]).try(:to_ordered_hash)
    end

    if manifest
      render json: JSON.pretty_generate(manifest.as_json)
    else
      head :not_found
    end
  end

  private

  # validate that the id is of the proper format
  def load_purl
    @purl = PurlResource.find(params[:id])
  end
end
