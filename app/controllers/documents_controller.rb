class DocumentsController < ApplicationController
  require 'nokogiri'
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  def index
    @documents = Document.all
  end

  # GET /documents/1
  def show
    document = Document.find_by_id(params[:id])
    (render_error(404, "Resource not found") and return) unless document
    respond_to do |format|
      format.xml { render :xml => create_xml(document) }
      format.json { render :json => create_json(document) }
    end
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  def create
    @document = Document.new(document_params)

    if @document.save
      redirect_to @document, notice: 'Document was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /documents/1
  def update
    if @document.update(document_params)
      redirect_to @document, notice: 'Document was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /documents/1
  def destroy
    @document.destroy
    redirect_to documents_url, notice: 'Document was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def document_params
      params.require(:document).permit(:content, :last_edit_by)
    end

    def create_xml(documents)
      documents = [documents] unless documents.class == Array
      xml = build_xml do |xml|
        xml.documents {
          documents.each do |document|
            xml.document(:id => document.id) {
              xml.content(document.content)
              xml.last_edit_by(document.last_edit_by)
              xml.updated_at(document.updated_at)
              xml.created_at(document.created_at)
            }
          end
        }
      end
    end
  
    def create_json(documents)
      documents = [documents] unless documents.class == Array
      documents = documents.inject([]){ |array, document|
        array << {
         :id => document.id,
          :content => document.content,
          :last_edit_by => document.last_edit_by,
          :updated_at => document.updated_at,
          :created_at => document.created_at
        }; array
      }
      { :documents => documents }.to_json
    end
  
    def build_xml(&block)
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') { |xml| yield(xml) }
      builder.to_xml
    end
  
    def render_error(status, msg)
      render :text => msg, :status => status
    end


end
