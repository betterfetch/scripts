const owner = "betterfetch";
const repo = "scripts";

fetch(`https://api.github.com/repos/${owner}/${repo}/commits`)
  .then((res) => res.json())
  .then((data) => {
    const latestCommit = data[0];
    const commitMessage = latestCommit.commit.message;
    const commitDate = new Date(
      latestCommit.commit.author.date
    ).toLocaleString();
    const commitUrl = latestCommit.html_url;
    const author = latestCommit.commit.author.name;

    document.getElementById("latest-commit").innerHTML = `
        Latest commit by <b>${author}</b> on ${commitDate}:
        <a href="${commitUrl}" target="_blank">${commitMessage}</a>
      `;
  })
  .catch((err) => console.error("Error fetching commits:", err));
