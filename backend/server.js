const app = require("./app");
const config = require("./src/config/config");
const supabase = require("./src/store/supabase");

const PORT = config.server.port || 5001;
const supabaseRunning = supabase;

app.listen(PORT, () => {
  console.log(`Server running on ${config.server.baseUrl}`);
});
