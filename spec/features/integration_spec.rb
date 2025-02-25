require 'rails_helper'

describe 'Integration Scenarios' do
  context 'with an EEMs object' do
    it 'works' do
      visit '/mr497sx5638'
      expect(page).to have_content 'Statewide water action plan for California'
    end
  end

  context 'book' do
    it 'works' do
      visit '/bb737zp0787'
      expect(page).to have_content 'The curate of Cumberworth ; and The vicar of Roost : tales'
      expect(page).to have_metadata_section 'Access conditions'
      expect(page).to have_metadata_section 'Description'
      expect(page).to have_metadata_section 'Contributors'
      expect(page).to have_content 'Creator Paget, Francis Edward, 1806-1882'
      expect(page).to have_metadata_section 'Bibliographic information'
      expect(page).to have_metadata_section 'Also listed in'
    end

    it 'has a link to the searchworks record' do
      visit '/bb737zp0787'
      expect(page).to have_link 'View in SearchWorks', href: 'https://searchworks.stanford.edu/view/9616533'
    end
  end

  context 'map' do
    it 'works' do
      visit '/py305sy7961'
      expect(page).to have_content 'Torrance, Los Angeles Co., Cal., Dec. 1929'
      expect(page).to have_metadata_section 'Access conditions'
      expect(page).to have_metadata_section 'Description'
      expect(page).to have_metadata_section 'Contributors'
      expect(page).to have_metadata_section 'Subjects'
    end

    it 'links to the creative commons license' do
      visit '/py305sy7961'
      expect(page).to have_selector '.creativeCommons-by-nc'
      expect(page).to have_link 'This work is licensed under a Creative Commons Attribution-Noncommercial 3.0 Unported License', href: 'http://creativecommons.org/licenses/by-nc/3.0/'
    end

    it 'adds mailto links in the use and reproduction statement' do
      visit '/py305sy7961'
      within '#access-conditions' do
        expect(page).to have_link 'brannerlibrary@stanford.edu', href: 'mailto:brannerlibrary@stanford.edu'
      end
    end
  end

  context 'etd' do
    it 'works' do
      visit '/nd387jf5675'
      expect(page).to have_content 'Invariance for perceptual recognition through deep learning'
      expect(page).to have_metadata_section 'Access conditions'
      expect(page).to have_metadata_section 'Description'
      expect(page).to have_metadata_section 'Contributors'
      expect(page).to have_metadata_section 'Abstract/Contents'
      expect(page).to have_metadata_section 'Subjects'
      expect(page).to have_metadata_section 'Bibliographic information'
      expect(page).to have_metadata_section 'Also listed in'
    end

    it 'links to the creative commons license' do
      visit '/nd387jf5675'
      expect(page).to have_selector '.creativeCommons-by-nc'
      expect(page).to have_link 'This work is licensed under a Creative Commons Attribution-Noncommercial 3.0 Unported License', href: 'http://creativecommons.org/licenses/by-nc/3.0/'
    end

    it 'has a link to the searchworks record' do
      visit '/nd387jf5675'
      expect(page).to have_link 'View in SearchWorks', href: 'https://searchworks.stanford.edu/view/10734942'
    end
  end

  context 'item released to searchworks' do
    it 'works' do
      visit '/cp088pb1682'
      expect(page).to have_content 'Atari Competition'
      expect(page).to have_metadata_section 'Access conditions'
      expect(page).to have_metadata_section 'Description'
      expect(page).to have_metadata_section 'Contributors'
      expect(page).to have_metadata_section 'Subjects'
      expect(page).to have_metadata_section 'Bibliographic information'
      expect(page).to have_metadata_section 'Also listed in'
    end

    it 'lists the collection name' do
      visit '/cp088pb1682'
      expect(page).to have_content 'Bay Area video arcades : photographs by Ira Nowinski, 1981-1982'
    end

    it 'has a link to the searchworks record' do
      visit '/cp088pb1682'
      expect(page).to have_link 'View in SearchWorks', href: 'https://searchworks.stanford.edu/view/cp088pb1682'
    end
  end

  context 'cabinet minutes' do
    it 'works' do
      visit '/gx074xz5520'
      expect(page).to have_content 'Minutes, 2006 May 18'
      expect(page).to have_metadata_section 'Access conditions'
      expect(page).to have_metadata_section 'Description'
      expect(page).to have_metadata_section 'Contributors'
      expect(page).to have_metadata_section 'Abstract/Contents'
      expect(page).to have_metadata_section 'Subjects'
      expect(page).to have_metadata_section 'Bibliographic information'
      expect(page).to have_metadata_section 'Contact information'
    end

    it 'lists the collection name' do
      visit '/gx074xz5520'
      expect(page).to have_content 'Stanford University, Cabinet, Records'
    end

    it 'lists the preferred citation' do
      visit '/gx074xz5520'
      expect(page).to have_content 'Stanford University. Cabinet, Stanford University--Administration'
    end

    it 'shows related items' do
      visit '/gx074xz5520'
      within '#bibliography-info' do
        expect(page).to have_link 'Finding aid', href: 'http://www.oac.cdlib.org/findaid/ark:/13030/kt1h4nf2fr/'
      end
    end

    it 'provides the archivesref contact information' do
      visit '/gx074xz5520'
      within '#contact' do
        expect(page).to have_link 'archivesref@stanford.edu', href: 'mailto:archivesref@stanford.edu'
      end
    end
  end

  context 'revs object' do
    it 'works' do
      visit '/tx027jv4938'
      expect(page).to have_content 'IMSA 24 Hours of Daytona'
      expect(page).to have_metadata_section 'Access conditions'
      expect(page).to have_metadata_section 'Description'
      expect(page).to have_metadata_section 'Contributors'
      expect(page).to have_metadata_section 'Subjects'
      expect(page).to have_metadata_section 'Bibliographic information'
    end

    it 'provides revs-specific subjects' do
      visit '/tx027jv4938'
      expect(page).to have_content 'Venue Daytona International Speedway'
      expect(page).to have_content 'Event 24 Hours of Daytona'
      expect(page).to have_content 'Revs ID 2012-015GHEW-BW-1984-b4_1.4_0003'
    end
  end
  def have_metadata_section(text)
    have_selector '.section-heading', text: text
  end
end
