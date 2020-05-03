require("dotenv").config();
const fetch = require("node-fetch");
const Discord = require("discord.js");
const Fuse = require("fuse.js");

const client = new Discord.Client();
client.login(process.env.DISCORD_TOKEN);

const url = "http://localhost:3001";
const prefix = "!";
const answer_prefix = "?";
const current = new Map();

client.on("ready", () => {
  console.log(`Logged in as ${client.user.tag}!`);
});

client.on("message", async (message) => {
  if (message.author.bot) return;
  if (!message.content.startsWith(prefix)) return;

  if (message.content.startsWith(`${prefix}trivia`)) {
    playTrivia(message);
    return;
  } else if (message.content.startsWith(`${prefix}delete`)) {
    clear(message);
    return;
  } else if (message.content.startsWith(`${prefix}leaderboard`)) {
    getLeader(message);
    return;
  } else if (message.content.startsWith(`${prefix}score`)) {
    getScore(message);
    return;
  } else if (message.content.startsWith(`${prefix}help`)) {
    getHelp(message);
    return;
  }
});

const playTrivia = async (message) => {
  const args = message.content.split(" ");
  try {
    let question = await getQuestion(
      `${url}/questions?difficulty=${args[1] ? "HARD" : "EASY"}`
    );
    current.set(message.guild.id, question);
    message.channel.send(
      question.text +
        "\nYou have 30 seconds to answer! Type ? before your response. Only your first response will be counted."
    );
    getResponses(question, message);
    return;
  } catch (err) {
    console.error(err);
    message.channel.send("Hmm. Unable to fetch a question. Please try again.");
    return;
  }
};

const getQuestion = async (url) => {
  try {
    const response = await fetch(url);
    const question = await response.json();
    console.log(question);
    question.responders = [];
    question.correct = [];
    return question;
  } catch (err) {
    console.log(err);
  }
};

const check = (message, answer) => {
  const response = [
    {
      response: message.content.slice(3),
      player: message.author.username,
    },
  ];
  const fuse = new Fuse(response, { keys: ["response"] });
  return fuse.search(answer);
};

const getResponses = async (question, message) => {
  const filter = (message) => {
    if (
      message.content.startsWith(answer_prefix) &&
      !question.responders.includes(message.author.username)
    ) {
      question.responders.push(message.author.username);
      const match = check(message, question.answer);
      return match.length ? true : false;
    } else {
      return false;
    }
  };

  const collector = message.channel.createMessageCollector(filter, {
    time: 30000,
  });

  collector.on("collect", async (msg) => {
    question.correct.push(msg.author.username);

    try {
      const player = await getPlayer(
        `${url}/players?player=${msg.author.username}&server=${msg.guild.id}`
      );
      const id = player.id;
      const value = question.value;
      try {
        await addPoints(`${url}/players/${id}?value=${value}`);
      } catch (err) {
        console.error(err);
      }
    } catch (err) {
      console.error(err);
    }
  });

  collector.on("end", async (collected) => {
    console.log(`Collected ${collected.size} items`);
    let correct = question.correct.length
      ? `The following players answered correctly: ${question.correct.join(
          " , "
        )}`
      : "Nobody answered correctly!";

    message.channel.send(
      `${correct}\nThe correct answer was: ${question.answer}`
    );
    await getLeader(message);
    current.delete(message.guild.id);
  });
};

const clear = async (message) => {
  const question = current.get(message.guild.id);
  if (!question) {
    message.channel.send("I didn't even ask a question!.");
  }

  try {
    const response = await fetch(`${url}/questions/${question.id}`, {
      method: "DELETE",
    });
    const json = await response.json();
    if (json.response) {
      message.channel.send("Question deleted.");
      current.delete(message.guild.id);
      return;
    }
  } catch (err) {
    console.error(err);
    message.channel.send("Something went wrong.");
    return;
  }
};

const getLeader = async (message) => {
  const args = message.content.split(" ");

  let path =
    message.content.startsWith(`${prefix}leaderboard`) && args[1]
      ? `/players?limit=${args[1]}&server=${message.guild.id}`
      : `/players?server=${message.guild.id}`;

  try {
    const response = await fetch(`${url}${path}`);
    let json = await response.json();
    if (!json.length) {
      return message.channel.send("The leaderboard is currently empty!");
    }
    let board = "";
    let i = 1;
    json.forEach((player) => {
      board += `${i}. ${player.name}: ${player.score}\n`;
      i++;
    });
    board = board.trim();
    return message.channel.send(`The current leaderboard is:\n ${board}`);
  } catch (err) {
    console.log(err);
  }
};

const getPlayer = async (url) => {
  let player;
  try {
    const get_response = await fetch(url);
    player = await get_response.json();
  } catch (err) {
    console.log(err);
  }

  if (player.error) {
    try {
      const post_response = await fetch(url, { method: "POST" });
      player = await post_response.json();
    } catch (err) {
      console.log(err);
    }
  }
  return player;
};

const getScore = async (message) => {
  try {
    const score = await getPlayer(
      `${url}/players?player=${message.author.username}&server=${message.guild.id}`
    );
    return message.reply(`your score is ${score}.`);
  } catch (err) {
    console.error(err);
  }
};

const addPoints = async (url) => {
  try {
    const response = await fetch(url, { method: "PATCH" });
    const json = await response.json();
    return json;
  } catch (err) {
    console.log(err);
  }
};

const getHelp = (message) => {
  return message.channel.send(
    `Available commands:\n${prefix}trivia {optional: easy or hard} to play\n${answer_prefix} {your response} to answer the question\n${prefix}delete to delete the question currently in play\n${prefix}leaderboard {optional limit} to see the current leaderboard for your server\n${prefix}score to see your score.`
  );
};
