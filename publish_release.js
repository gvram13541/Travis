const fs = require('fs')

let nextReleaseTag, latestReleaseTag

if(latestReleaseTag === undefined){
    nextReleaseTag = "r10001"
} else{
    let releaseNumber = /^r([0-9]+)$/g.exec(latestReleaseTag.name)[1]
    nextReleaseTag = "r" + (parseInt(releaseNumber)+1)
}

console.log("new Tag", nextReleaseTag)

fs.writeFile('releaseNumber.txt', nextReleaseTag, (err) => {
    if(err) throw err
    console.log('File releaseNumber.txt has been created with the new release tag.')
})