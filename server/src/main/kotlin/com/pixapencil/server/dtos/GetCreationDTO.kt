package com.pixapencil.server.dtos

import com.pixapencil.server.domain.Creation

data class Author(val username: String, val profilePictureUrl: String)

data class GetCreationDTO(
    val title: String,
    val description: String,
    val coverImageUrl: String,
    val createdAt: String,
    val author: Author,
)

fun Creation.toGetCreationDTO(): GetCreationDTO {
    return GetCreationDTO(
        title = this.title,
        description = this.description,
        coverImageUrl = "https://pixapencil-gallery.s3.ap-southeast-2.amazonaws.com/" + this.coverImageUrl,
        createdAt = this.createdAt.toString(),
        author = Author(
            username = this.user.username,
            profilePictureUrl = "https://pixapencil-gallery.s3.ap-southeast-2.amazonaws.com/" + this.user.profilePictureUrl
        ),
    )
}