const fs = require('fs')

let nextReleaseTag, latestReleaseTag

if(latestReleaseTag === undefined){
    nextReleaseTag = "r100"
} else{
    let releaseNumber = /^r([0-9]+)$/g.exec(latestReleaseTag.name)[1]
    nextReleaseTag = "r" + (parseInt(releaseNumber)+1)
}

console.log(releaseNumber)
console.log("new Tage", nextReleaseTag)

fs.writeFile('releaseNumber.txt', nextReleaseTag, (err) => {
    if(err) throw err
})