const { exec, spawn } = require("child_process");
const fs = require("fs");

console.log("🚀 Starting PayrollPro with Auto-Commit...");

// Configure git
exec('git config user.name "dev-itredstone"', (error) => {
  if (error) console.log("Git config name error:", error.message);
});

exec('git config user.email "dev.itredstone@gmail.com"', (error) => {
  if (error) console.log("Git config email error:", error.message);
});

// Auto-commit function
function autoCommit() {
  exec("git status --porcelain", (error, stdout) => {
    if (error) {
      console.log("Git status error:", error.message);
      return;
    }

    if (stdout.trim()) {
      console.log("📁 Changes detected, committing...");
      const commitMessage = `🌀 Auto-commit from Replit on ${new Date().toISOString()}`;

      exec("git add .", (addError) => {
        if (addError) {
          console.log("Git add error:", addError.message);
          return;
        }

        exec(`git commit -m "${commitMessage}"`, (commitError) => {
          if (commitError) {
            console.log("Git commit error:", commitError.message);
            return;
          }

          console.log("✅ Changes committed");

          exec("git push origin main", (pushError) => {
            if (pushError) {
              console.log("❌ Push failed:", pushError.message);
            } else {
              console.log("🚀 Changes pushed successfully");
            }
          });
        });
      });
    }
  });
}

// Start auto-commit monitoring
console.log("🔍 Starting auto-commit monitor...");
setInterval(autoCommit, 10000); // Check every 10 seconds

// Start the main application
console.log("💡 Auto-commit is running in background");
console.log("🚀 Starting npm dev server...");

const npmProcess = spawn("npm", ["run", "dev"], {
  stdio: "inherit",
  shell: true,
});

npmProcess.on("close", (code) => {
  console.log(`npm process exited with code ${code}`);
  process.exit(code);
});

// Handle process termination
process.on("SIGINT", () => {
  console.log("\n🛑 Shutting down...");
  npmProcess.kill();
  process.exit(0);
});
