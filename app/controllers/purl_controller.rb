require "dor/util"

class PurlController < ApplicationController

  before_filter :validate_id

  # entry point into the application
  def index

    @purl = Purl.new
    @purl.extract_metadata(params[:id])

    # validate that the id is ready for delivery
    if( !Dor::Util.is_shelved?(params[:id]) )
      render :partial => "purl/unavailable", :layout => "application"
      return false
    end

    # render the landing page based on the format
    respond_to do |format|
      format.html
      format.xml { render :xml => @purl.public_xml }
    end
  end

  private

  # validate that the id is of the proper format
  def validate_id
    
    # handle a single static grandfathered exception
    if(params[:id] == 'ir:rs276tc2764')
      redirect_to "/ir:rs276tc2764/index.html"
      return
    end

    if( !Dor::Util.validate_druid(params[:id]) )
      render :status => 404, :file => "#{RAILS_ROOT}/public/404.html"
      return false
    end
    true
  end

end

