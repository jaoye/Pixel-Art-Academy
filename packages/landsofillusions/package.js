Package.describe({
  name: 'retronator:landsofillusions',
  version: '0.1.0',
  // Brief, one-line summary of the package.
  summary: 'Game engine for Pixel Art Academy, Retropolis and beyond.',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/Retronator/Lands-of-Illusions.git',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('retronator:artificialengines');
  api.use('retronator:retronator-accounts');
  api.use('http');
  api.use('promise');
  api.use('modules');

  api.imply('retronator:artificialengines');
  api.imply('retronator:retronator-accounts');

  api.export('LandsOfIllusions');

  api.addFiles('landsofillusions.coffee');

  // Authorize

  api.addFiles('authorize/authorize.coffee');
  api.addFiles('authorize/user.coffee');
  api.addFiles('authorize/character.coffee');

  // Assets

  api.addFiles('assets/assets.coffee');
  api.addFiles('assets/server.coffee');

  api.addFiles('assets/palette/palette.coffee');
  api.addFiles('assets/palette/atari2600.coffee');
  api.addFiles('assets/palette/subscriptions.coffee', 'server');

  api.addFiles('assets/sprite/sprite.coffee');

  api.addFiles('assets/mesh/mesh.coffee');

  // Game state

  api.addFiles('state/gamestate.coffee');
  api.addFiles('state/localgamestate.coffee');
  api.addFiles('state/methods.coffee');
  api.addFiles('state/subscriptions.coffee', 'server');
  api.addFiles('state/stateobject.coffee');
  api.addFiles('state/statefield.coffee');
  api.addFiles('state/stateaddress.coffee');
  api.addFiles('state/stateinstances.coffee');
  api.addFiles('state/ephemeralstateobject.coffee');
  api.addFiles('state/localsavegames.coffee');

  api.addServerFile('state/migrations/0000-immersionrevamp');

  // Character

  api.addClientFile('character/spacebars');
  api.addFile('character/character');
  api.addFile('character/methods');
  api.addServerFile('character/subscriptions');
  api.addServerFile('character/migrations/0000-renamecollection');
  api.addServerFile('character/migrations/0001-userpublicname');
  api.addServerFile('character/migrations/0002-ownername');
  api.addServerFile('character/migrations/0003-migrateavatarfields');

  // Avatar

  api.addFiles('avatar/avatar.coffee');

  // Conversations

  api.addFiles('conversations/conversations.coffee');
  api.addFiles('conversations/conversation.coffee');
  api.addFiles('conversations/line.coffee');
  api.addFiles('conversations/methods.coffee');
  api.addFiles('conversations/subscriptions.coffee', 'server');

  // Parser

  api.addFiles('parser/parser.coffee');
  api.addFiles('parser/parser-likelyactions.coffee');
  api.addFiles('parser/command.coffee');
  api.addFiles('parser/commandresponse.coffee');
  api.addFiles('parser/enterresponse.coffee');
  api.addFiles('parser/exitresponse.coffee');

  api.addFiles('parser/vocabulary/vocabulary.coffee');
  api.addFiles('parser/vocabulary/vocabularykeys.coffee');
  api.addFiles('parser/vocabulary/english-server.coffee', 'server');

  // Director

  api.addFiles('director/director.coffee');

  // Adventure

  api.addFiles('adventure/adventure.html');
  api.addFiles('adventure/adventure.styl');
  api.addFiles('adventure/adventure.coffee');
  api.addFiles('adventure/adventure-routing.coffee');
  api.addFiles('adventure/adventure-state.coffee');
  api.addFiles('adventure/adventure-location.coffee');
  api.addFiles('adventure/adventure-timeline.coffee');
  api.addFiles('adventure/adventure-item.coffee');
  api.addFiles('adventure/adventure-inventory.coffee');
  api.addFiles('adventure/adventure-episodes.coffee');
  api.addFiles('adventure/adventure-things.coffee');
  api.addFiles('adventure/adventure-listeners.coffee');
  api.addFiles('adventure/adventure-time.coffee');
  api.addFiles('adventure/adventure-dialogs.coffee');

  // Initalization gets included last because it does component registering as the last child in the chain.
  api.addFiles('adventure/adventure-initialization.coffee');

  // Situations

  api.addFiles('adventure/situation/situation.coffee');
  api.addFiles('adventure/situation/circumstance.coffee');

  // Listener

  api.addFiles('adventure/listener/listener.coffee');
  
  // Things

  api.addFiles('adventure/thing/thing.coffee');
  api.addFiles('adventure/thing/thing.html');

  api.addFiles('adventure/item/item.coffee');

  // Script

  api.addFiles('adventure/script/scriptfile.coffee');
  api.addFiles('adventure/script/script.coffee');

  api.addFiles('adventure/script/helpers/helpers.coffee');
  api.addFiles('adventure/script/helpers/iteminteraction.coffee');
  api.addFiles('adventure/script/helpers/inventory.coffee');
  api.addFiles('adventure/script/helpers/location.coffee');

  api.addFiles('adventure/script/node.coffee');
  api.addFiles('adventure/script/nodes/nodes.coffee');
  api.addFiles('adventure/script/nodes/script.coffee');
  api.addFiles('adventure/script/nodes/label.coffee');
  api.addFiles('adventure/script/nodes/callback.coffee');
  api.addFiles('adventure/script/nodes/dialogline.coffee');
  api.addFiles('adventure/script/nodes/narrativeline.coffee');
  api.addFiles('adventure/script/nodes/interfaceline.coffee');
  api.addFiles('adventure/script/nodes/commandline.coffee');
  api.addFiles('adventure/script/nodes/code.coffee');
  api.addFiles('adventure/script/nodes/conditional.coffee');
  api.addFiles('adventure/script/nodes/jump.coffee');
  api.addFiles('adventure/script/nodes/choice.coffee');
  api.addFiles('adventure/script/nodes/timeout.coffee');
  api.addFiles('adventure/script/nodes/pause.coffee');

  api.addFiles('adventure/script/parser/parser.coffee');

  // Storylines

  api.addFiles('adventure/global/global.coffee');
  api.addFiles('adventure/episode/episode.coffee');
  api.addFiles('adventure/section/section.coffee');
  api.addComponent('adventure/chapter/chapter');
  api.addFiles('adventure/scene/scene.coffee');

  // Locations and inventory

  api.addFiles('adventure/region/region.coffee');
  api.addFiles('adventure/location/location.coffee');
  api.addFiles('adventure/location/inventory.coffee');

  // Parser Listeners

  api.addFiles('parser/listeners/debug.coffee');
  api.addFiles('parser/listeners/navigation.coffee');
  api.addFiles('parser/listeners/description.coffee');
  api.addFiles('parser/listeners/looklocation.coffee');

  // Interface

  api.addFiles('interface/interface.coffee');

  api.addFiles('interface/components/components.coffee');
  api.addFiles('interface/components/narrative.coffee');
  api.addFiles('interface/components/commandinput.coffee');
  api.addFiles('interface/components/dialogselection.coffee');

  api.addFiles('interface/text/text.coffee');
  api.addFiles('interface/text/text.html');
  api.addFiles('interface/text/text.styl');
  api.addFiles('interface/text/text-initialization.coffee');
  api.addFiles('interface/text/text-handlers.coffee');
  api.addFiles('interface/text/text-nodehandling.coffee');
  api.addFiles('interface/text/text-resizing.coffee');
  api.addFiles('interface/text/text-scrolling.coffee');

  // Pages

  api.addFiles('pages/pages.coffee');
  api.addFiles('pages/loading/loading.coffee');
  api.addFiles('pages/loading/loading.html');
  api.addFiles('pages/loading/loading.styl');

  // Components

  api.addFiles('components/components.coffee');

  api.addFile('components/mixins/mixins');
  api.addFile('components/mixins/activatable/activatable');

  api.addComponent('components/overlay/overlay');
  api.addComponent('components/backbutton/backbutton');
  api.addComponent('components/signin/signin');
  api.addComponent('components/chaptertitle/chaptertitle');

  api.addComponent('components/menu/menu');
  api.addComponent('components/menu/items/items');

  api.addComponent('components/account/account');
  api.addFile('components/account/account-page');
  api.addStyle('components/account/account-pagecontent');

  api.addComponent('components/account/contents/contents');
  api.addComponent('components/account/general/general');
  api.addComponent('components/account/services/services');
  api.addComponent('components/account/characters/characters');
  api.addComponent('components/account/inventory/inventory');
  api.addComponent('components/account/transactions/transactions');

  api.addStyle('components/dialogs/accounts');
  api.addComponent('components/dialogs/dialog');
  
  api.addComponent('components/translationinput/translationinput');

  // Typography

  api.addFiles('typography/typography.css', 'client');
  api.addFiles('typography/typography.import.styl', 'client', {isImport:true});

  // Styles

  api.addFiles('style/style.import.styl', 'client', {isImport:true});
  api.addFiles('style/atari2600.import.styl', 'client', {isImport:true});
  api.addFiles('style/cursors.import.styl', 'client', {isImport:true});
  api.addFiles('style/cursors.styl');
  api.addFiles('style/defaults.styl');

  // Helpers

  api.addFiles('helpers/spacebars.coffee');
  api.addFiles('helpers/lodash.coffee');

});
