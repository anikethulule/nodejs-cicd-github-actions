async function checkHealth() {
  const statusText = document.getElementById("statusText");

  try {
    const response = await fetch("/health");
    const data = await response.json();

    if (data.status === "UP") {
      statusText.innerText = `Application Status: ${data.status}`;
    } else {
      statusText.innerText = "Application Status: Unknown";
    }
  } catch (error) {
    statusText.innerText = "Application Status: Not reachable";
  }
}

checkHealth();