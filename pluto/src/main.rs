///
/// Pluto - Dotfile manager
/// Pluto is a program to setup and manage dotfiles
///

extern crate clap;

use std::process::Command;
use std::path::{ PathBuf };

use clap::{Arg, App, AppSettings, SubCommand};

#[derive(Debug)]
struct Link {
    source: PathBuf,
    destination: PathBuf,
}

impl Link {
    fn new(source: PathBuf, destination: PathBuf) -> Self {
        Self {
            source: source,
            destination: destination,
        }
    }

    fn do_link(&self) -> Option<()> {
        // TODO(patrik): Check if the source exists
        let output = Command::new("ln")
                        .arg("-s")
                        .arg(self.source.as_path())
                        .arg(self.destination.as_path())
                        .output()
                        .ok()?;

        println!("Output: {}", String::from_utf8_lossy(&output.stdout));
        println!("Error: {}", String::from_utf8_lossy(&output.stderr));
        println!("Status: {}", output.status);

        return if !output.status.success() {
            None
        } else {
            Some(())
        };
    }
}

#[derive(Debug)]
enum Platform {
    General,
    Desktop,
    Laptop,
}

#[derive(Debug)]
enum OperatingSystem {
    Linux,
}

#[derive(Debug)]
struct Config<'a> {
    name: &'a str,
    links: Vec<Link>,

    platform: Platform,
    os: OperatingSystem,
}

impl<'a> Config<'a> {
    fn new(name: &'a str, links: Vec<Link>) -> Self {
        Self {
            name,
            links,

            platform: Platform::General,
            os: OperatingSystem::Linux,
        }
    }

    fn setup(&self) {
        for link in &self.links {
            match link.do_link() {
                Some(_) => {
                    println!("Linking: {} -> {}", link.source.to_str().unwrap(), link.destination.to_str().unwrap());
                },

                None => {
                    println!("Linking (FAILED): {} -> {}", link.source.to_str().unwrap(), link.destination.to_str().unwrap());
                }
            }
        }
    }
}

#[derive(Debug)]
struct SetupOption {
    force: bool,
}

impl Default for SetupOption {
    fn default() -> Self {
        Self {
            force: false
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
                .long("force"));

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

fn main() {
    let command = parse_command_line();
    println!("Command: {:?}", command);

    let link = Link::new(PathBuf::from("testing/doom"), PathBuf::from("testing/doom.d"));

    let config = Config::new("Doom Emacs", vec![link]);
    println!("Config: {:#?}", config);

    config.setup();

    let meta = std::fs::symlink_metadata("./target").unwrap();
    println!("Meta: {:#?}", meta);
}
