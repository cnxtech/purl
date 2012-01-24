require 'nokogiri'

require "dor/util"

class Purl
  
  include PurlHelper
  
  def Purl.find(id)
    pair_tree = Purl.create_pair_tree(id)
    return nil if(pair_tree.nil?)
    
    file_path = File.join(DOCUMENT_CACHE_ROOT,pair_tree)
    # This will catch well formatted druids that do not have a directory in the document cache
    return nil unless(File.exists?(file_path))
    
    Purl.new(id)
  end
  
  #
  # This method returns the pair tree directory structure based on the given object identifier.
  # The object identifier must be of the following format, otherwise nil is returned.
  #
  #     druid:xxyyyxxyyyy
  #
  #       where 'x' is an alphabetic character
  #       where 'y' is a numeric character
  #
  def Purl.create_pair_tree(pid)
    if(pid =~ /^([a-z]{2})(\d{3})([a-z]{2})(\d{4})$/)
      return File.join($1, $2, $3, $4)
    else
      return nil
    end
  end

  DEFERRED_TEMPLATE = %{def %1$s; extract_metadata unless @extracted; instance_variable_get("@%1$s"); end}
  def self.attr_deferred(*args)
    args.each { |a| eval(DEFERRED_TEMPLATE % a) }
  end
  
  attr_accessor :pid
  attr_accessor :public_xml
  attr_accessor :mods_xml
  
  attr_deferred :titles, :authors, :source, :date, :relation, :description, :contributors        # dc
  attr_deferred :degreeconfyr, :cclicense, :cclicensetype, :cclicense_symbol                     # properties
  attr_deferred :catalog_key                                                                     # identity
  attr_deferred :read_group, :embargo_release_date, :copyright_stmt, :use_and_reproduction_stmt  # rights
  attr_deferred :deliverable_files, :type                                                        # content

  NAMESPACES = {     
    'oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/", 
    'dc' => 'http://purl.org/dc/elements/1.1/', 
    'dcterms' => 'http://purl.org/dc/terms/'
  }

  def initialize(id)
    @pid = id
    @public_xml = get_metadata('public')
    @mods_xml = get_metadata('mods')
    @extracted = false
  end

  def extract_metadata
    doc = ng_xml('dc','identityMetadata','contentMetadata','rightsMetadata','properties')
    
    # DC Metadata
    dc = doc.root.at_xpath('*[local-name() = "dc"]', NAMESPACES)
    unless dc.nil?
      @titles       = dc.xpath('dc:title/text()|dcterms:title/text()', NAMESPACES).collect { |t| t.to_s + " " }
      @authors      = dc.xpath('dc:creator/text()|dcterms:creator/text()', NAMESPACES).collect { |t| t.to_s }
      @contributors = dc.xpath('dc:contributor/text()|dcterms:contributor/text()', NAMESPACES).collect { |t| t.to_s + '<br/>' }      
      @source       = dc.at_xpath('dc:source/text()', NAMESPACES).to_s
      @date         = dc.at_xpath('dc:date/text()', NAMESPACES).to_s
      @description  = dc.xpath('dc:description/text()|dcterms:abstract/text()', NAMESPACES).collect { |t| '<p>' + t.to_s + '</p>' }      
      @relation     = dc.at_xpath('dc:relation/text()', NAMESPACES).to_s.gsub /^Collection\s*:\s*/, ''
    end
    
    # Identity Metadata
    @catalog_key = doc.root.at_xpath('identityMetadata/otherId[@name="catkey"]/text()').to_s
    
    # Content Metadata
    @type = doc.root.xpath('contentMetadata/@type').to_s
    
    @deliverable_files = doc.root.xpath('contentMetadata/resource/file[not(@deliver="no" or @publish="no")]').collect do |file|
      resource = Resource.new
      resource.mimetype = file['mimetype']
      resource.size     = file['size']
      resource.shelve   = file['shelve']
      resource.preserve = file['preserve']
      resource.deliver  = file['deliver'] || file['publish']
      resource.filename = file['id']
      resource.objectId = file.parent['objectId']
      resource.type     = file.parent['type']
      resource.width    = file.at_xpath('imageData/@width').to_s
      resource.height   = file.at_xpath('imageData/@height').to_s
      resource.imagesvc = file.at_xpath('location[@type="imagesvc"]/text()').to_s
      resource.url      = file.at_xpath('location[@type="url"]/text()').to_s
      
      if !file.parent.at_xpath('attr[@name="label"]/text()').nil?
        resource.description_label = file.parent.at_xpath('attr[@name="label"]/text()').to_s
      elsif !file.parent.at_xpath('label/text()').nil?
        resource.description_label = file.parent.at_xpath('label/text()').to_s
      end
      
      resource
    end
    
    # Rights Metadata
    rights = doc.root.at_xpath('rightsMetadata')
    unless rights.nil?
      read = rights.at_xpath('access[@type="read"]/machine/*')
      
      unless read.nil?
        @read_group = read.name == 'group' ? read.text : read.name
      end
      
      @embargo_release_date = rights.at_xpath(".//embargoReleaseDate/text()").to_s
      
      if( !@embargo_release_date.nil? and @embargo_release_date != '' )
        embargo_date_time = Time.parse(@embargo_release_date)
        @embargo_release_date = '' unless embargo_date_time.future?
      end
      
      @copyright_stmt = rights.at_xpath('copyright/human/text()').to_s 
      @use_and_reproduction_stmt = rights.at_xpath('use/human[@type="useAndReproduction"]/text()').to_s           
      @cclicense_symbol = rights.at_xpath('use/machine[@type="creativeCommons"]/text()').to_s
      
      if (@cclicense_symbol.nil? || @cclicense_symbol.empty?)
        @cclicense_symbol = rights.at_xpath('use/machine[@type="creativecommons"]/text()').to_s
      end
    end
    
    # Properties
    fields = doc.root.at_xpath('fields|properties/fields')
    unless fields.nil?
      @degreeconfyr  = fields.at_xpath("degreeconfyr/text()").to_s
      @cclicense     = fields.at_xpath("cclicense/text()").to_s
      @cclicensetype = fields.at_xpath("cclicensetype/text()").to_s
    end
    @extracted = true
  end
  
  def is_ready?
    if !@public_xml.nil? and !@public_xml.empty? and @public_xml != "<public/>"
      return true
    end
    
    false
  end
  
  # check if this object is of type image
  def is_image?
    if !type.nil? && type =~ /Image|Map|Manuscript/i
      return true
    end  
    
    false
  end
  
  # check if this object has mods content
  def has_mods
    if !@mods_xml.nil? and !@mods_xml.empty? and @mods_xml != "<mods/>"    
      return true
    end
    
    false
  end    
    
  private

  # retrieve the given document from the document cache for the given object identifier
  def get_metadata(doc_name)
    pair_tree = Purl.create_pair_tree(@pid)
    contents = "<#{doc_name}/>"
    
    unless pair_tree.nil?
      file_path = File.join(DOCUMENT_CACHE_ROOT,pair_tree,doc_name)
      
      if File.exists?(file_path)
        contents = File.read(file_path)
      end
      
      if( !RAILS_ENV.eql? 'production' )
        contents.gsub!('stacks.stanford.edu','stacks-test.stanford.edu')
      end
    end

    return contents
  end

  def ng_xml(*streams)
    if @ng_xml.nil?
      content = @public_xml

      if content.nil? or content.strip.empty?
        content = "<publicObject objectId='#{@pid}'/>"
      end

      @ng_xml = Nokogiri::XML(content)

      streams.each do |doc_name|
        if @ng_xml.root.at_xpath(%{*[local-name() = "#{doc_name}"]}).nil?
          stream_content = get_metadata(doc_name)
          unless stream_content.empty?
            @ng_xml.root.add_child(Nokogiri::XML(stream_content).root)
          end
        end
      end
    end
    @ng_xml
  end

end
