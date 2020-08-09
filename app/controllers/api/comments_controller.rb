class Api::CommentsController < ApplicationController

    before_action :ensure_logged_in, only: [:create, :destroy]

    def index
        if params[:track_id]
            @comments = Track.find(params[:track_id]).comments
        else
            @comments = Comment.all
        end
        render :index
        #render json: @comments
    end

    def create
        @comment = Comment.new(comment_params)
        @comment.author_id = current_user.id

        if @comment.save!
            render 'api/comments/show'
        else
            render json: @comment.errors.full_messages, status: 422
        end
    end

    def destroy
        @comment = Comment.find(params[:id])

        if @comment.author_id == current_user.id
            @comment.destroy
            render 'api/comments/show'
        else
            render json: @comment.errors.full_messages, status: 422
        end
    end


    private

    def comment_params
        params.require(:comment).permit(:comment_body, :author_id, :track_id)
    end

end
