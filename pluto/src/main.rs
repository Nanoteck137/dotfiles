///
/// Pluto - Dotfile manager
/// Pluto is a program to setup and manage dotfiles
///

extern crate clap;
extern crate path_absolutize;
#[macro_use] extern crate serde_derive;

use std::process::Command;
use std::path::{ Path, PathBuf };
use clap::{Arg, App, AppSettings, SubCommand};
use path_absolutize::*;

#[derive(Deserialize, Debug)]
struct Link {
    source: String,
    destination: String,
}

impl Link {
    fn new(source: String, destination: String) -> Self {
        Self {
            source: source,
            destination: destination,
        }
    }

    fn do_link(&self) -> Option<()> {
        // TODO(patrik): Check if the source exists
        let output = Command::new("ln")
                        .arg("-s")
                        .arg(&self.source)
                        .arg(&self.destination)
                        .output()
                        .ok()?;

        return if !output.status.success() {
            None
        } else {
            Some(())
        };
    }
}

#[derive(Deserialize, Debug)]
enum Platform {
    General,
    Desktop,
    Laptop,
}

impl Default for Platform {
    fn default() -> Self {
        Self::General
    }
}

#[derive(Deserialize, Debug)]
enum OperatingSystem {
    Linux,
}

impl Default for OperatingSystem {
    fn default() -> Self {
        Self::Linux
    }
}

#[derive(Deserialize, Debug)]
struct PlutoObject {
    name: String,
    links: Vec<Link>,

    #[serde(default = "Platform::default")]
    platform: Platform,
    #[serde(default = "OperatingSystem::default")]
    os: OperatingSystem,
}

impl PlutoObject {
    fn new(name: String, links: Vec<Link>) -> Self {
        Self {
            name,
            links,

            platform: Platform::General,
            os: OperatingSystem::Linux,
        }
    }

    fn setup(&self) {
        println!("Setting up: {}", self.name);
        for link in &self.links {
            match link.do_link() {
                Some(_) => {
                    println!("Linking: {} -> {}", link.source, link.destination);
                },

                None => {
                    println!("Linking (FAILED): {} -> {}", link.source, link.destination);
                }
            }
        }
    }
}

#[derive(Debug)]
struct SetupOption {
    force: bool,
    config: String,
}

impl Default for SetupOption {
    fn default() -> Self {
        Self {
            force: false,
            config: "pluto.json".to_string(),
        }
    }
}

#[derive(Debug)]
enum PlutoCommand {
    Setup(SetupOption),
    Check
}

fn parse_command_line() -> PlutoCommand {
    let setup_command =
        SubCommand::with_name("setup")
            .arg(Arg::with_name("force")
                .short("-f")
                .long("force"))
            .arg(Arg::with_name("config")
                    .short("-c")
                    .long("config"));

    let check_command = SubCommand::with_name("check");

    let matches =
        App::new("Pluto")
            .version("0.1")
            .author("Patrik Millvik Rosenström <patrik.millvik@gmail.com>")
            .about("Dotfile manager")
            .subcommand(setup_command)
            .subcommand(check_command)
            .setting(AppSettings::SubcommandRequiredElseHelp)
            .get_matches();

    return match matches.subcommand() {
        ("setup", submatch) => {
            let submatch = submatch.unwrap();

            let mut options = SetupOption::default();
            if submatch.is_present("force") {
                options.force = true;
            }

            let config_path = submatch.value_of("config").unwrap_or("pluto.json");
            options.config = config_path.to_string();

            PlutoCommand::Setup(options)
        },

        ("check", _) => {
            PlutoCommand::Check
        },

        _ => {
            panic!("Unknown subcommand");
        }
    };
}

fn get_prefix() -> String {
    return match std::env::var("PLUTO_DEST_PREFIX") {
        Ok(val) => {
            val
        }

        Err(e) => {
            match std::env::var("HOME") {
                Ok(val) => val,
                Err(e) => {
                    println!("Failed to find $HOME enviroment variable");
                    std::process::exit(-1);
                }
            }
        }
    };
}

fn run_setup(options: &SetupOption) {
    let json_content = std::fs::read_to_string(&options.config).unwrap();

    let mut objects = match serde_json::from_str::<Vec<PlutoObject>>(&json_content) {
        Ok(o) => o,
        Err(e) => {
            println!("Config Error:");
            println!("{}", e);
            std::process::exit(-1);
        }
    };

    let prefix = get_prefix();

    // Process all the objects from the json and
    // fix up the path so they are absolute paths
    for obj in objects.iter_mut() {
        for link in obj.links.iter_mut() {
            let source = std::path::Path::new(&link.source);
            (*link).source = String::from(source.absolutize().unwrap().to_str().unwrap());

            let mut destination = PathBuf::from(&prefix);
            destination.push(&link.destination);
            (*link).destination = String::from(destination.to_str().unwrap());
        }
    }

    println!("{:#?}", objects);

    for obj in &objects {
        obj.setup();
        println!();
    }
}

fn main() {
    let command = parse_command_line();
    println!("Command: {:?}", command);

    match command {
        PlutoCommand::Setup(opt) => run_setup(&opt),
        PlutoCommand::Check => {
            unimplemented!("Check is not implemented");
        }

        _ => {
            panic!("Unknown command");
        }
    }
}
